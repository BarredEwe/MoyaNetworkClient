import Foundation

public struct Future<Response> {
    public typealias Callback = (Response) -> Void
    public let run: (@escaping Callback) -> Void

    public init(run: @escaping (@escaping Callback) -> Void) {
        self.run = run
    }

    public init(value: Response) {
        self.init(run: { $0(value) })
    }

    public init(work: @escaping () -> Response) {
        self.init(run: { $0(work()) })
    }

    public func execute() {
        run { _ in }
    }
}

extension Future {

    public func map<NewResponse>(_ transform: @escaping (Response) -> NewResponse) -> Future<NewResponse> {
        return Future<NewResponse> { callback in
            self.run { callback(transform($0)) }
        }
    }

    public func flatMap<NewResponse>( _ transform: @escaping (Response) -> Future<NewResponse>) -> Future<NewResponse> {
        return Future<NewResponse> { callback in
            self.run { transform($0).run(callback) }
        }
    }

    public func observe(_ callback: @escaping (Response) -> Void) -> Future {
        return self.map {
            callback($0)
            return $0
        }
    }

}
