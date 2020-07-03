import Moya
import Foundation
import Alamofire

public typealias Result<Success> = Swift.Result<Success, Error>
public typealias Completion<Value> = (Result<Value>) -> Void

public typealias DefaultMoyaNC = MoyaNC<MoyaNCError>

@available(*, deprecated, renamed: "DefaultMoyaNC")
public typealias DefaultMoyaNetworkClient = MoyaNC<MoyaNCError>

@available(*, deprecated, renamed: "MoyaNC")
public class MoyaNetworkClient<ErrorType: Error & Decodable>: MoyaNC<ErrorType> { }

/// Request provider class. Requests should be made through this class only.
public class MoyaNC<ErrorType: Error & Decodable> {

    internal var jsonDecoder: JSONDecoder
    internal var provider: MoyaProvider<MultiTarget>
    internal var requests = [String: Request]()

    public init(jsonDecoder: JSONDecoder = JSONDecoder(),
                provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])) {
        self.jsonDecoder = jsonDecoder
        self.provider = provider
    }

    @discardableResult
    public func request<Value: Codable>(_ target: BaseTargetType, _ completion: @escaping Completion<Value>) -> Request {
        return providerRequest(target, completion)
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
            synced(self) { self.requests.removeValue(forKey: requestId) }
        }
        let request = RequestAdapter(cancellable: cancelable)
        synced(self) { requests[requestId] = request }
        return request
    }

    internal func process<Value: Codable>(response: Response, _ target: BaseTargetType, _ completion: @escaping Completion<Value>) {
        do {
            var result: Value
            switch Value.self {
            case is URL.Type: result = target.destinationURL as! Value
            case is Data.Type: result = response.data as! Value
            case is String.Type: result = try response.mapJSON() as! Value
            default: result = try response.map(Value.self, atKeyPath: target.keyPath, using: self.jsonDecoder, failsOnEmptyData: false)
            }
            completion(.success(result))
        } catch let error {
            if let result = try? response.mapJSON(), let object = result as? Value {
                return completion(.success(object))
            }
            completion(.failure(error))
        }
    }

    internal func process(error: Error, response: Response?) -> Error {
        guard let response = response else { return error }
        if let customError = try? response.map(ErrorType.self) { return customError }
        if let errorInfo = try? response.mapString(), !errorInfo.isEmpty { return MoyaNCError(error: errorInfo) }
        return error
    }

    internal func isCancelledError(_ error: MoyaError, requestId: String) -> Bool {
        guard case .underlying(let swiftError, _) = error else { return false }
        objc_sync_enter(self)
        guard let currentRequest = requests[requestId] else { return false }
        objc_sync_exit(self)
        return currentRequest.isCancelled && (swiftError as NSError).localizedDescription == AFError.explicitlyCancelled.localizedDescription
    }
}
