import Moya

public protocol MultiTargetType: TargetType {
    var keyPath: String? { get }
    var destinationURL: URL? { get }
}

public extension MultiTargetType {
    var keyPath: String? {
        return nil
    }

    var destinationURL: URL? {
        return nil
    }

    var headers: [String : String]? {
        return nil
    }
}
