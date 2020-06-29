import Moya

internal class SimpleCancellable: Cancellable {
    var isCancelled = false
    func cancel() {
        isCancelled = true
    }
}
