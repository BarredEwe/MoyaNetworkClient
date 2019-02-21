import Moya

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public typealias Completion<T> = (Result<T>) -> Void

public class MoyaNetworkClient<ErrorType: Error & Decodable> {

    private let jsonDecoder = JSONDecoder()
    private var provider: MoyaProvider<MultiTarget>
    private var currentRequest: Request?

    public init(dateFormatter: DateFormatter = DateFormatter(),
                provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])) {
        self.provider = provider
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }

    public func request<T: Codable>(_ target: MultiTargetType, _ completion: @escaping (Result<T>) -> Void) -> Request {
        let cancelable = provider.request(MultiTarget(target)) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.filterSuccessfulStatusCodes()
                    var result: T
                    switch T.self {
                    case is URL.Type: result = target.destinationURL as! T
                    case is Data.Type: result = response.data as! T
                    default: result = try response.map(T.self, atKeyPath: target.keyPath, using: self.jsonDecoder, failsOnEmptyData: false)
                    }
                    completion(.success(result))
                } catch let error {
                    if let result = try? response.mapJSON(), let object = result as? T {
                        completion(.success(object))
                        return
                    }

                    var error = error
                    if let customError = try? response.map(ErrorType.self) { error = customError }
                    print("There was something wrong with the request! Error: \(error)")
                    completion(.failure(error))
                }
            case let .failure(error):
                print("There was something wrong with the request! Error: \(error)")
                if self.isCancelledError(error) { return }
                completion(.failure(error))
            }
        }
        let request = RequestAdapter(cancellable: cancelable)
        currentRequest = request
        return request
    }

    private func isCancelledError(_ error: MoyaError) -> Bool {
        guard case .underlying(let swiftError, _) = error else { return false }
        guard let currentRequest = currentRequest else { return false }
        return (swiftError as NSError).code == NSURLErrorCancelled && currentRequest.isCancelled
    }
}
