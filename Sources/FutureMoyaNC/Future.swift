import Foundation

public struct Future<Response> {
    public typealias Callback = (Response) -> Void
    public let run: (@escaping Callback) -> Void

    @inlinable
    public init(run: @escaping (@escaping Callback) -> Void) {
        self.run = run
    }

    @inlinable
    public init(value: Response) {
        self.init(run: { $0(value) })
    }

    @inlinable
    public init(work: @escaping () -> Response) {
        self.init(run: { $0(work()) })
    }

    @inlinable
    public func execute() {
        run { _ in }
    }
}

extension Future {

    @inlinable
    public func map<NewResponse>(_ transform: @escaping (Response) -> NewResponse) -> Future<NewResponse> {
        return Future<NewResponse> { callback in
            self.run { callback(transform($0)) }
        }
    }

    @inlinable
    public func flatMap<NewResponse>( _ transform: @escaping (Response) -> Future<NewResponse>) -> Future<NewResponse> {
        return Future<NewResponse> { callback in
            self.run { transform($0).run(callback) }
        }
    }

    @inlinable
    public func observe(_ callback: @escaping (Response) -> Void) -> Future {
        return self.map {
            callback($0)
            return $0
        }
    }

    @inlinable
    public static func async(_ future: Future, delay: TimeInterval = 0, on queue: DispatchQueue, completesOn completionQueue: DispatchQueue = .main) -> Future {
        return Future { cb in
            queue.asyncAfter(deadline: .now() + delay) {
                future.run { value in
                    completionQueue.async {
                        cb(value)
                    }
                }
            }
        }
    }

    @inlinable
    public func async( delay: TimeInterval = 0, on queue: DispatchQueue, completesOn completionQueue: DispatchQueue = .main) -> Future {
        return Future.async(self, delay: delay, on: queue, completesOn: completionQueue)
    }

    @inlinable
    public func asyncOnMain() -> Future {
        return async(on: .main, completesOn: .main)
    }

    @inlinable
    public func parallel<NewResponse>(_ a: Future<NewResponse>, completesOn completionQueue: DispatchQueue = .main) -> Future<(Response, NewResponse)> {
        return createParallelWith(self, a, completesOn: completionQueue) { ($0, $1) }
    }

    @inlinable
    public func parallelWith<NewResponse, FinalResponse>(_ fA: Future<NewResponse>, completesOn completionQueue: DispatchQueue = .main,
                                             combine: @escaping (Response, NewResponse) -> FinalResponse) -> Future<FinalResponse> {
        return createParallelWith(self, fA, completesOn: completionQueue, combine: combine)
    }

    @inlinable
    func createParallelWith<A, B, FinalResponse>(_ fA: Future<A>, _ fB: Future<B>, completesOn completionQueue: DispatchQueue = .main,
                                                  combine: @escaping (A, B) -> FinalResponse) -> Future<FinalResponse> {
        return Future<FinalResponse> { callback in

            let maybeCompleted: (A?, B?) -> Void = {
                guard let a = $0, let b = $1 else { return }
                callback(combine(a, b))
            }

            var a: A?
            var b: B?

            fA.async(on: .global(), completesOn: completionQueue).run {
                a = $0
                maybeCompleted(a, b)
            }

            fB.async(on: .global(), completesOn: completionQueue).run {
                b = $0
                maybeCompleted(a, b)
            }
        }
    }

}
