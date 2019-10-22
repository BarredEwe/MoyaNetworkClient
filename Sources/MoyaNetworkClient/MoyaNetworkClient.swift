import Moya
import Foundation

public typealias Result<Success> = Swift.Result<Success, Error>
public typealias Completion<Value> = (Result<Value>) -> Void

@available(*, deprecated, renamed: "DefaultMoyaNC")
public typealias DefaultMoyaNetworkClient = MoyaNetworkClient<MoyaNCError>
public typealias DefaultMoyaNC = MoyaNetworkClient<MoyaNCError>

public class MoyaNetworkClient<ErrorType: Error & Decodable> {

    internal var jsonDecoder: JSONDecoder
    internal var provider: MoyaProvider<MultiTarget>
    internal var requests = [String: Request]()

    public init(jsonDecoder: JSONDecoder = JSONDecoder(),
                provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])) {
        self.jsonDecoder = jsonDecoder
        self.provider = provider
    }

    @discardableResult
    public func request<Value: Codable>(_ target: BaseTargetType, _ completion: @escaping Completion<Value>) -> Request {
        #if canImport(Cache)
        return providerRequest(target, cachePolicy: target.cachePolicy, completion)
        #else
        return providerRequest(target, completion)
        #endif
    }

    // MARK: Private Methods
    @discardableResult
    internal func providerRequest<Value: Codable>(_ target: BaseTargetType, _ completion: @escaping Completion<Value>) -> Request {
        let requestId = UUID().uuidString
        let cancelable = provider.request(MultiTarget(target)) { result in
            switch result {
            case let .success(response):
                self.process(response: response, target, completion)
            case let .failure(error):
                if self.isCancelledError(error, requestId: requestId) { return }
                let error = self.process(error: error, response: error.response)
                print("There was something wrong with the request! Error: \(error)")
                completion(.failure(error))
            }
            objc_sync_enter(self)
            self.requests.removeValue(forKey: requestId)
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        let request = RequestAdapter(cancellable: cancelable)
        requests[requestId] = request
        objc_sync_exit(self)
        return request
    }

    internal func process<Value: Codable>(response: Response, _ target: BaseTargetType, _ completion: @escaping Completion<Value>) {
        do {
            let response = try response.filterSuccessfulStatusCodes()
            var result: Value
            switch Value.self {
            case is URL.Type: result = target.destinationURL as! Value
            case is Data.Type: result = response.data as! Value
            default: result = try response.map(Value.self, atKeyPath: target.keyPath, using: self.jsonDecoder, failsOnEmptyData: false)
            }
            #if canImport(Cache)
            objc_sync_enter(self)
            ResponseCache.cacheData(target, data: response)
            objc_sync_exit(self)
            #endif
            completion(.success(result))
        } catch let error {
            if let result = try? response.mapJSON(), let object = result as? Value {
                #if canImport(Cache)
                objc_sync_enter(self)
                ResponseCache.cacheData(target, data: response)
                objc_sync_exit(self)
                #endif
                completion(.success(object))
                return
            }
            let error = self.process(error: error, response: response)
            completion(.failure(error))
        }
    }

    internal func process(error: Error, response: Response?) -> Error {
        if let response = response, let customError = try? response.map(ErrorType.self) { return customError }
        return error
    }

    internal func isCancelledError(_ error: MoyaError, requestId: String) -> Bool {
        guard case .underlying(let swiftError, _) = error else { return false }
        objc_sync_enter(self)
        guard let currentRequest = requests[requestId] else { return false }
        objc_sync_exit(self)
        return (swiftError as NSError).code == NSURLErrorCancelled && currentRequest.isCancelled
    }
}
