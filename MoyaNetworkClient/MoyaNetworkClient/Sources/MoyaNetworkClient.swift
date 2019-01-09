import Moya

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public typealias Completion<T> = (Result<T>) -> Void

public class MoyaNetworkClient<ErrorType: Error & Decodable> {

    private let jsonDecoder = JSONDecoder()
    private var provider: MoyaProvider<MultiTarget>

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
                    let result: T
                    switch T.self {
                    case is String.Type: result = try response.mapJSON() as! T
                    case is URL.Type: result = target.destinationURL as! T
                    case is Data.Type: result = response.data as! T
                    default: result = try response.map(T.self, atKeyPath: target.keyPath, using: self.jsonDecoder, failsOnEmptyData: false)
                    }
                    completion(.success(result))
                } catch let error {
                    guard let customError = try? response.map(ErrorType.self) else {
                        completion(.failure(error))
                        return
                    }
                    print("There was something wrong with the request! Error: \(error)")
                    completion(.failure(customError))
                }
            case let .failure(error):
                print("There was something wrong with the request! Error: \(error)")
                if self.isCancelledError(error) { return }
                completion(.failure(error))
            }
        }
        return RequestAdapter(cancellable: cancelable)
    }

    private func isCancelledError(_ error: MoyaError) -> Bool {
        guard case .underlying(let swiftError, _) = error else { return false }
        return (swiftError as NSError).code == NSURLErrorCancelled
    }
}
