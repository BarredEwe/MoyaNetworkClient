import Moya

/// Default In-memory cache implementation.
public final class MemoryCacheStorage: CacheStorage {

    public static let shared = MemoryCacheStorage()

    public var storage: [CachingKey: Codable] = [:]

    public func removeAll() {
        storage.removeAll()
    }

    public func remove(for key: CachingKey) {
        storage.removeValue(forKey: key)
    }

    public func store<Value: Codable>(_ value: Value, for key: CachingKey) {
        storage[key] = value
    }

    public func fetch<Value: Codable>(for key: CachingKey) -> Value? {
        return storage[key] as? Value
    }
}
