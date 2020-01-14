import Moya
#if !COCOAPODS && canImport(FutureMoyaNC)
import MoyaNC
import FutureMoyaNC
#endif

#if COCOAPODS || canImport(FutureMoyaNC)
extension MoyaNC {
    @discardableResult
    public func request<Value: Codable>(_ target: MoyaCacheTarget) -> FutureResult<Value> {
        return request(target, cache: target.cachePolicy)
    }

    @discardableResult
    public func request<Value: Codable>(_ target: MoyaCacheTarget, cache: MoyaCachePolicy) -> FutureResult<Value> {
        return FutureResult<Value> { completion in
            self.processCache(target, cachePolicy: cache) { result in completion(result) }
        }
    }
}
#endif
