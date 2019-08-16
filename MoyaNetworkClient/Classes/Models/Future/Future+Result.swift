import Foundation

public typealias FutureResult<Value> = Future<Result<Value>>

extension Future {
    public func mapResult<Success, NewSuccess>(_ transform: @escaping (Success) -> NewSuccess) -> FutureResult<NewSuccess>
        where Response == Result<Success> {
            return self.map { $0.map(transform) }
    }


    public func mapResultError<Success>(_ transform: @escaping (Error) -> Error) -> FutureResult<Success>
        where Response == Result<Success> {
            return self.map { $0.mapError(transform) }
    }


    public func flatMapResult<Success, NewSuccess>(_ transform: @escaping (Success) -> FutureResult<NewSuccess>) -> FutureResult<NewSuccess>
        where Response == Result<Success> {
            return self.flatMap { result in
                FutureResult<NewSuccess> { callback in
                    switch result {
                    case let .success(s):
                        transform(s).run { callback($0) }
                    case let .failure(error):
                        callback(.failure(error))
                    }
                }
            }
    }

    public func flatMapResultError<Success>(_ transform: @escaping (Error) -> FutureResult<Success>) -> FutureResult<Success>
        where Response == Result<Success> {
            return self.flatMap { result in
                FutureResult<Success> { callback in
                    switch result {
                    case let .success(s):
                        callback(.success(s))
                    case let .failure(error):
                        transform(error).run { callback($0) }
                    }
                }
            }
    }

    public func observeResultSuccess<Success>(_ callback: @escaping (Success) -> Void) -> Future
        where Response == Result<Success> {
            return self.mapResult {
                callback($0)
                return $0
            }
    }

    public func observeResultError<Success>(_ callback: @escaping (Error) -> Void) -> Future
        where Response == Result<Success> {
            return self.mapResultError {
                callback($0)
                return $0
            }
    }
}

