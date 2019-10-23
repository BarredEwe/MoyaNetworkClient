import Moya
#if !COCOAPODS
    import MoyaNC
#endif

extension MoyaNC {

    internal class SimpleCancellable: Cancellable {
        var isCancelled = false
        func cancel() {
            isCancelled = true
        }
    }

    @discardableResult
    public func request<Value: Codable>(_ target: BaseTargetType, cache: MoyaCachePolicy,
                                        _ completion: @escaping Completion<Value>) -> Request {
        guard let cacheRequest = processCache(target, cachePolicy: cache, completion) else { return request(target, completion) }
        return cacheRequest
    }

    @discardableResult
    internal func providerRequest<Value: Codable>(_ target: BaseTargetType, cachePolicy: MoyaCachePolicy,
                                                  _ completion: @escaping Completion<Value>) -> Request {
        if let request = processCache(target, cachePolicy: cachePolicy, completion) {
            return request
        }
        return providerRequest(target, completion)
    }

    @discardableResult
    internal func processCache<Value: Codable>(_ target: BaseTargetType, cachePolicy: MoyaCachePolicy,
                                               _ completion: @escaping Completion<Value>) -> Request? {
        switch cachePolicy {
            // TODO: Process all cachePolicy
        case .useProtocolCachePolicy, .reloadIgnoringLocalCacheData, .reloadIgnoringLocalAndRemoteCacheData, .reloadRevalidatingCacheData:
            break
        case .returnCacheDataElseLoad:
            if let responseCache = getCache(for: target) {
                process(response: responseCache, target, completion)
                return RequestAdapter(cancellable: SimpleCancellable())
            }
        case .returnCacheDataDontLoad:
            if let responseCache = getCache(for: target) {
                process(response: responseCache, target, completion)
            } else {
                // TODO: Return error
            }
            return RequestAdapter(cancellable: SimpleCancellable())
        @unknown default: break
        }
        return nil
    }

    internal func getCache(for target: BaseTargetType) -> Response? {
        let cacheKey = ResponseCache.uniqueKey(target)
        return try? ResponseCache.shared.responseStorage?.object(forKey: cacheKey)
    }
}

