
/// Protocol describing cache interaction.
public protocol CacheTarget {
    /// The constants used to specify interaction with the cached responses. (default: .notUseCache)
    var cachePolicy: MoyaCachePolicy { get }

    /// Used to store and retrieve data from the cache.
    var cacheStorage: CacheStorage? { get }
}

public extension CacheTarget {
    var cachePolicy: MoyaCachePolicy {
        return .notUseCache
    }

    var cacheStorage: CacheStorage? {
        return cachePolicy == .notUseCache ? nil : MemoryCacheStorage.shared
    }
}
