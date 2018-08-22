import Foundation
import Moya

public protocol Request {
    var isCancelled: Bool { get }
    func cancel()
}

class RequestAdapter: Request {

    private let cancellable: Cancellable

    var isCancelled: Bool

    init(cancellable: Cancellable) {
        self.cancellable = cancellable
        isCancelled = cancellable.isCancelled
    }

    func cancel() {
        if !isCancelled {
            isCancelled = true
            cancellable.cancel()
        }
    }
}
