/// Protocol describing cache interaction.
public protocol CacheTarget {
    /// The constants used to specify interaction with the cached responses. (default: .notUseCache)
    var cachePolicy: MoyaCachePolicy { get }

    /// Used to store and retrieve data from the cache.
    var cacheStorage: CacheStorage? { get }

    /// Used to set a custom key value for caching.
    var cachingKey: CachingKey { get }
}

public extension CacheTarget {
    var cachePolicy: MoyaCachePolicy {
        return .notUseCache
    }

    var cacheStorage: CacheStorage? {
        return cachePolicy == .notUseCache ? nil : MemoryCacheStorage.shared
    }

    var cachingKey: CachingKey {
        return (self as? MoyaCacheTarget).flatMap { CachingKey(target: $0) } ?? String(describing: self)
    }
}
