import Moya
#if !COCOAPODS
import MoyaNC
#endif

#if COCOAPODS
extension MoyaNC {
    @discardableResult
    public func request<Value: Codable>(_ target: MoyaCacheTarget) -> FutureResult<Value> {
        return request(target, cachePolicy: target.cachePolicy)
    }

    @discardableResult
    public func request<Value: Codable>(_ target: MoyaCacheTarget, cachePolicy: MoyaCachePolicy) -> FutureResult<Value> {
        return FutureResult<Value> { completion in
            self.processCache(target, cachePolicy: cachePolicy) { result in completion(result) }
        }
    }
}
#elseif canImport(FutureMoyaNC)
import FutureMoyaNC

extension MoyaNC {
    @discardableResult
    public func request<Value: Codable>(_ target: MoyaCacheTarget) -> FutureResult<Value> {
        return request(target, cachePolicy: target.cachePolicy)
    }

    @discardableResult
    public func request<Value: Codable>(_ target: MoyaCacheTarget, cachePolicy: MoyaCachePolicy) -> FutureResult<Value> {
        return FutureResult<Value> { completion in
            self.processCache(target, cachePolicy: cachePolicy) { result in completion(result) }
        }
    }
}
#endif
