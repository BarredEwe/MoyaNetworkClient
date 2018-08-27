import Moya

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public class MoyaNetworkClient {

    private enum ResultType {
        case object
        case simple
    }

    private let jsonDecoder: JSONDecoder
    private var provider: MoyaProvider<MultiTarget>

    public init(dateFormatter: DateFormatter = DateFormatter(),
                provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])) {
        self.provider = provider
        jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }

    public func request(_ target: MultiTargetType, _ completion: @escaping (Result<SimpleData>) -> Void) -> Request {
        return request(target: target, resultType: .simple, completion: completion)
    }

    public func request<T: Codable>(_ target: MultiTargetType, _ completion: @escaping (Result<T>) -> Void) -> Request {
        return request(target: target, resultType: .object, completion: completion)
    }

    private func request<T: Codable>(target: MultiTargetType, resultType: ResultType, completion: @escaping (Result<T>) -> Void) -> Request {
        let cancelable = provider.request(MultiTarget(target)) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.filterSuccessfulStatusCodes()
                    let result: T
                    switch resultType {
                    case .object:
                        result = try response.map(T.self, atKeyPath: target.keyPath, using: self.jsonDecoder, failsOnEmptyData: false)
                    case .simple:
                        result = SimpleData(content: "\(try response.mapJSON())") as! T
                    }
                    completion(.success(result))
                } catch let error {
                    print("There was something wrong with the request! Error: \(error)")
                    completion(.failure(error))
                }
            case let .failure(error):
                print("There was something wrong with the request! Error: \(error)")
                if self.isCancelledError(error) {
                    return
                }
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
