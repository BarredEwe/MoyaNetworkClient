import Foundation

public protocol NetworkClient {
    func request(_ target: MultiTargetType, _ completion: @escaping (Result<SimpleData>) -> Void) -> Request
    func request<T: Codable>(_ target: MultiTargetType, _ completion: @escaping (Result<T>) -> Void) -> Request
}

public enum Result<T> {
    case success(T)
    case failure(Error)
}
