import Foundation
#if !COCOAPODS
import MoyaNC
#endif

/// The key to uniquely identify the request provider.
public typealias CachingKey = String

public extension CachingKey {
    init(target: BaseTargetType) {
        let baseInfo = target.path + target.method.rawValue + (target.headers?.sorted(by: { $0.key > $1.key }).description ?? "") + (target.keyPath ?? "")
        switch target.task {
        case let .requestParameters(parameters, _):
            self = baseInfo + parameters.sorted(by: { $0.key > $1.key }).description
        case let .requestCompositeData(bodyData, urlParameters):
            self = baseInfo + urlParameters.sorted(by: { $0.key > $1.key }).description + String(bodyData.hashValue)
        case let .requestCompositeParameters(bodyParameters, _, urlParameters):
            self = baseInfo + urlParameters.sorted(by: { $0.key > $1.key }).description + bodyParameters.sorted(by: { $0.key > $1.key }).description
        default:
            self = baseInfo
        }
    }
}
