import Foundation
import Moya

public protocol Request {
    var isCancelled: Bool { get }
    func cancel()
}

public class RequestAdapter: Request {

    private let cancellable: Cancellable

    public var isCancelled: Bool

    public init(cancellable: Cancellable) {
        self.cancellable = cancellable
        isCancelled = cancellable.isCancelled
    }

    public func cancel() {
        if !isCancelled {
            isCancelled = true
            cancellable.cancel()
        }
    }
}
