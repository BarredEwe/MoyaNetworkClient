import Moya

public typealias Result<Success> = Swift.Result<Success, Error>
public typealias Completion<Value> = (Result<Value>) -> Void

public typealias DefaultMoyaNetworkClient = MoyaNetworkClient<MoyaNCError>

public class MoyaNetworkClient<ErrorType: Error & Decodable> {

    private let jsonDecoder = JSONDecoder()
    private var provider: MoyaProvider<MultiTarget>
    private var requests = [String: Request]()

    public init(dateFormatter: DateFormatter = DateFormatter(),
                provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])) {
        self.provider = provider
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }

    @discardableResult public func request<Value: Codable>(_ target: MultiTargetType, _ completion: @escaping Completion<Value>) -> Request {
        return providerRequest(target, completion)
    }

    @discardableResult public func request<Value: Codable>(_ target: MultiTargetType) -> FutureResult<Value> {
        return FutureResult<Value> { completion in
            self.providerRequest(target) { (result: Result<Value>) in
                switch result {
                case let .success(value): completion(.success(value))
                case let .failure(error): completion(.failure(error))
                }
            }
        }
    }

    // MARK: Private Methods
    @discardableResult private func providerRequest<Value: Codable>(_ target: MultiTargetType, _ completion: @escaping Completion<Value>) -> Request {
        let requestId = UUID().uuidString
        let cancelable = provider.request(MultiTarget(target)) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.filterSuccessfulStatusCodes()
                    var result: Value
                    switch Value.self {
                    case is URL.Type: result = target.destinationURL as! Value
                    case is Data.Type: result = response.data as! Value
                    default: result = try response.map(Value.self, atKeyPath: target.keyPath, using: self.jsonDecoder, failsOnEmptyData: false)
                    }
                    completion(.success(result))
                } catch let error {
                    if let result = try? response.mapJSON(), let object = result as? Value {
                        completion(.success(object))
                        return
                    }
                    let error = self.process(error: error, response: response)
                    completion(.failure(error))
                }
            case let .failure(error):
                if self.isCancelledError(error, requestId: requestId) { return }
                let error = self.process(error: error, response: error.response)
                print("There was something wrong with the request! Error: \(error)")
                completion(.failure(error))
            }
            self.requests.removeValue(forKey: requestId)
        }
        let request = RequestAdapter(cancellable: cancelable)
        requests[requestId] = request
        return request
    }

    private func process(error: Error, response: Response?) -> Error {
        if let response = response, let customError = try? response.map(ErrorType.self) { return customError }
        return error
    }

    private func isCancelledError(_ error: MoyaError, requestId: String) -> Bool {
        guard case .underlying(let swiftError, _) = error else { return false }
        guard let currentRequest = requests[requestId] else { return false }
        return (swiftError as NSError).code == NSURLErrorCancelled && currentRequest.isCancelled
    }
}
