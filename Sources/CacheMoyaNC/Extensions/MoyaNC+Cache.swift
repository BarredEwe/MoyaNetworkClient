import Foundation
#if !COCOAPODS
import MoyaNC
#endif

/// Type describing Cache target.
public typealias MoyaCacheTarget = BaseTargetType & CacheTarget

extension MoyaNC {

    @discardableResult
    public func request<Value: Codable>(_ target: MoyaCacheTarget, _ completion: @escaping Completion<Value>) -> Request {
        return processCache(target, cachePolicy: target.cachePolicy, completion)
    }

    @discardableResult
    public func request<Value: Codable>(_ target: MoyaCacheTarget, cache: MoyaCachePolicy,
                                        _ completion: @escaping Completion<Value>) -> Request {
        return processCache(target, cachePolicy: cache, completion)
    }

    // MARK: Private Methods
    @discardableResult
    internal func cacheProviderRequest<Value: Codable>(_ target: MoyaCacheTarget, cache: MoyaCachePolicy, _ completion: @escaping Completion<Value>) -> Request {
        return request(target as BaseTargetType) { (result: Result<Value>) in
            switch result {
            case let .success(value): self.storeCache(value: value, for: target, with: cache)
            case .failure: break
            }
            completion(result)
        }
    }

    @discardableResult
    internal func processCache<Value: Codable>(_ target: MoyaCacheTarget, cachePolicy: MoyaCachePolicy, _ completion: @escaping Completion<Value>) -> Request {
        switch cachePolicy {
        case .returnCacheDataElseLoad:
            guard let cacheValue: Value = getCache(for: target) else { return cacheProviderRequest(target, cache: cachePolicy, completion) }
            completion(.success(cacheValue))
        case .returnCacheDataDontLoad:
            if let cacheValue: Value = getCache(for: target) {
                completion(.success(cacheValue))
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in cache"])
                print("An error occurred while retrieving data from the cache! Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        case .reloadIgnoringCacheData: return cacheProviderRequest(target, cache: cachePolicy, completion)
        default: break
        }
        return RequestAdapter(cancellable: SimpleCancellable())
    }

    internal func getCache<Value: Codable>(for target: MoyaCacheTarget) -> Value? {
        print("Getting cache for the request: .\(target.method.rawValue)(\(target.baseURL.absoluteString + target.path))")
        return target.cacheStorage?.fetch(for: target)
    }

    internal func storeCache<Value: Codable>(value: Value, for target: MoyaCacheTarget, with cache: MoyaCachePolicy) {
        guard cache != .notUseCache else { return }
        print("Saving the cache for the request: .\(target.method.rawValue)(\(target.baseURL.absoluteString + target.path))")
        objc_sync_enter(self)
        target.cacheStorage?.store(value, for: target)
        objc_sync_exit(self)
    }
}
