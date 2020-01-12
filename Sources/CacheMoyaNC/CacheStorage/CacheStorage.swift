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
    func remove(for target: BaseTargetType) {
        remove(for: CachingKey(target: target))
    }

    func store<Value: Codable>(_ value: Value, for target: BaseTargetType) {
        store(value, for: CachingKey(target: target))
    }

    func fetch<Value: Codable>(for target: BaseTargetType) -> Value? {
        return fetch(for: CachingKey(target: target))
    }
}
