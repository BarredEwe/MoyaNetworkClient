import Foundation
#if !COCOAPODS
import MoyaNC
#endif

/// The key to uniquely identify the request provider.
public typealias CachingKey = String

public extension CachingKey {
    init(target: BaseTargetType) {
        let baseInfo = target.method.rawValue + String(target.headers.hashValue) + (target.keyPath ?? "")
        switch target.task {
        case let .requestParameters(parameters, _):
            self = baseInfo + target.path + parameters.sorted(by: { $0.key > $1.key }).description
        case let .requestCompositeData(bodyData, urlParameters):
            self = baseInfo + urlParameters.sorted(by: { $0.key > $1.key }).description + String(bodyData.hashValue)
        case let .requestCompositeParameters(bodyParameters, _, urlParameters):
            self = baseInfo + urlParameters.sorted(by: { $0.key > $1.key }).description +
                bodyParameters.sorted(by: { $0.key > $1.key }).description
        default:
            self = baseInfo + target.path
        }
    }
}
