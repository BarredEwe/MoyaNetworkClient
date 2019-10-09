import Foundation
import Cache
import Moya

public typealias MoyaCachePolicy = NSURLRequest.CachePolicy

public enum ResponseStatusCode: Int {
    case cache = 230
    case loadFail = 700
}

fileprivate extension TransformerFactory {
    static func forResponse<T: Moya.Response>(_ type: T.Type) -> Transformer<T> {
        let toData: (T) throws -> Data = { $0.data }
        let fromData: (Data) throws -> T = {
            T(statusCode: ResponseStatusCode.cache.rawValue, data: $0)
        }
        return Transformer<T>(toData: toData, fromData: fromData)
    }
}

private struct CacheName {
    static let MoyaResponse = "cache.com.MoyaNCResponse"
}

public struct ResponseCache {
    public static let shared = ResponseCache()
    private init() {}

    let responseStorage = try? Storage<Moya.Response>(
        diskConfig: DiskConfig(name: CacheName.MoyaResponse),
        memoryConfig: MemoryConfig(),
        transformer: TransformerFactory.forResponse(Moya.Response.self)
    )

    public func removeAllCache() {
        try? responseStorage?.removeAll()
    }

    public func removeCache(api: BaseTargetType) {
        let cacheKey = ResponseCache.uniqueKey(api)
        try? responseStorage?.removeObject(forKey: cacheKey)
    }

    static func cacheData(_ api: BaseTargetType, data: Response) {
        let cacheKey = ResponseCache.uniqueKey(api)
        try? ResponseCache.shared.responseStorage?.setObject(data, forKey: cacheKey)
    }

    static func uniqueKey(_ api: BaseTargetType) -> String {
        switch api.task {
        case let .requestParameters(parameters, _):
            return api.path + parameters.description
        case let .requestCompositeData(bodyData, urlParameters):
            return api.path + urlParameters.description + String(bodyData.hashValue)
        case let .requestCompositeParameters(bodyParameters, _, urlParameters):
            return api.path + urlParameters.description + bodyParameters.description
        default:
            return api.path
        }
    }
}
