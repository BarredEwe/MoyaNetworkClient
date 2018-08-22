import Moya

public protocol MultiTargetType: TargetType {
    var keyPath: String? { get }
}
