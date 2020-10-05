#if !COCOAPODS
import MoyaNC
#endif

/// A protocol representing a minimal interface for working with a cache.
public protocol CacheStorage {
    func removeAll()
    func remove(for key: CachingKey)
    func store<Value: Codable>(_ value: Value, for key: CachingKey)
    func fetch<Value: Codable>(for key: CachingKey) -> Value?
}

public extension CacheStorage {
    func remove(for target: MoyaCacheTarget) {
        remove(for: target.cachingKey)
    }

    func store<Value: Codable>(_ value: Value, for target: MoyaCacheTarget) {
        store(value, for: target.cachingKey)
    }

    func fetch<Value: Codable>(for target: MoyaCacheTarget) -> Value? {
        fetch(for: target.cachingKey)
    }
}
