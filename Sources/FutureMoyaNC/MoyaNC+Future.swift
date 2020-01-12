import Moya
#if !COCOAPODS
import MoyaNC
#endif

extension MoyaNC {
    @discardableResult
    public func request<Value: Codable>(_ target: BaseTargetType) -> FutureResult<Value> {
        return FutureResult<Value> { completion in
            self.request(target) { result in completion(result) }
        }
    }
}
