import Moya

public protocol MultiTargetType: TargetType {
    var keyPath: String? { get }
}

public typealias Completion<T> = (Result<T>) -> Void
