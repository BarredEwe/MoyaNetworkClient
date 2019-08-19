import Foundation

public typealias FutureResult<Value> = Future<Result<Value>>

extension Future {
    public func mapResult<Success, NewSuccess>(_ transform: @escaping (Success) -> NewSuccess) -> FutureResult<NewSuccess>
        where Response == Result<Success>, Success: Codable {
            return map { $0.map(transform) }
    }


    public func mapResultError<Success>(_ transform: @escaping (Error) -> Error) -> FutureResult<Success>
        where Response == Result<Success>, Success: Codable {
            return map { $0.mapError(transform) }
    }


    public func flatMapResult<Success, NewSuccess>(_ transform: @escaping (Success) -> FutureResult<NewSuccess>?) -> FutureResult<NewSuccess>
        where Response == Result<Success>, Success: Codable, NewSuccess: Codable {
            return flatMap { result in
                FutureResult<NewSuccess> { callback in
                    switch result {
                    case let .success(s):
                        if let transform = transform(s) {
                            transform.run { callback($0) }
                        } else {
                            callback(.failure(NSError()))
                        }
                    case let .failure(error):
                        callback(.failure(error))
                    }
                }
            }
    }

    public func flatMapResultError<Success>(_ transform: @escaping (Error) -> FutureResult<Success>?) -> FutureResult<Success>
        where Response == Result<Success>, Success: Codable {
            return flatMap { result in
                FutureResult<Success> { callback in
                    switch result {
                    case let .success(s):
                        callback(.success(s))
                    case let .failure(error):
                        if let transform = transform(error) {
                            transform.run { callback($0) }
                        } else {
                            callback(.failure(error))
                        }
                    }
                }
            }
    }

    public func observeResultSuccess<Success>(_ callback: @escaping (Success) -> Void) -> Future
        where Response == Result<Success>, Success: Codable {
            return mapResult {
                callback($0)
                return $0
            }
    }

    public func observeResultError<Success>(_ callback: @escaping (Error) -> Void) -> Future
        where Response == Result<Success>, Success: Codable {
            return mapResultError {
                callback($0)
                return $0
            }
    }
}


