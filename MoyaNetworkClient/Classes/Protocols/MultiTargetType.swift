import Moya

public protocol MultiTargetType: TargetType {

    /// Used to parse Codable on this key.
    var keyPath: String? { get }

    /// When downloading files, you need to specify this url
    var destinationURL: URL? { get }

    /// Returns `Route` which contains HTTP method and URL path information.
    var route: Route { get }
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

    var path: String {
        return route.path
    }

    var method: Moya.Method {
        return route.method
    }
}
