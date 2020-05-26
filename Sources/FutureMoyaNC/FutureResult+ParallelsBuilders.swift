import Foundation
#if !COCOAPODS
import MoyaNC
#endif

extension FutureResult {
    @inlinable
    public func parallel<S1, S2, NewResponse>(_ a: FutureResult<NewResponse>, completesOn completionQueue: DispatchQueue = .main)
        -> FutureResult<(S1, S2, NewResponse)> where Response == Result<(S1, S2)> {
            return parallel(a, completesOn: completionQueue, combine: { ($0.0, $0.1, $1) })
    }

    @inlinable
    public func parallel<S1, S2, S3, NewResponse>(_ a: FutureResult<NewResponse>, completesOn completionQueue: DispatchQueue = .main)
        -> FutureResult<(S1, S2, S3, NewResponse)> where Response == Result<(S1, S2, S3)> {
            return parallel(a, completesOn: completionQueue, combine: { ($0.0, $0.1, $0.2, $1) })
    }

    @inlinable
    public func parallel<S1, S2, S3, S4, NewResponse>(_ a: FutureResult<NewResponse>, completesOn completionQueue: DispatchQueue = .main)
        -> FutureResult<(S1, S2, S3, S4, NewResponse)> where Response == Result<(S1, S2, S3, S4)> {
            return parallel(a, completesOn: completionQueue, combine: { ($0.0, $0.1, $0.2, $0.3, $1) })
    }

    @inlinable
    public func parallel<S1, S2, S3, S4, S5, NewResponse>(_ a: FutureResult<NewResponse>, completesOn completionQueue: DispatchQueue = .main)
        -> FutureResult<(S1, S2, S3, S4, S5, NewResponse)> where Response == Result<(S1, S2, S3, S4, S5)> {
            return parallel(a, completesOn: completionQueue, combine: { ($0.0, $0.1, $0.2, $0.3, $0.4, $1) })
    }

    @inlinable
    public func parallel<S1, S2, S3, S4, S5, S6, NewResponse>(_ a: FutureResult<NewResponse>, completesOn completionQueue: DispatchQueue = .main)
        -> FutureResult<(S1, S2, S3, S4, S5, S6, NewResponse)> where Response == Result<(S1, S2, S3, S4, S5, S6)> {
            return parallel(a, completesOn: completionQueue, combine: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $1) })
    }

    @inlinable
    public func parallel<S1, S2, S3, S4, S5, S6, S7, NewResponse>(_ a: FutureResult<NewResponse>, completesOn completionQueue: DispatchQueue = .main)
        -> FutureResult<(S1, S2, S3, S4, S5, S6, S7, NewResponse)> where Response == Result<(S1, S2, S3, S4, S5, S6, S7)> {
            return parallel(a, completesOn: completionQueue, combine: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $1) })
    }

    @inlinable
    public func parallel<S1, S2, S3, S4, S5, S6, S7, S8, NewResponse>(_ a: FutureResult<NewResponse>, completesOn completionQueue: DispatchQueue = .main)
        -> FutureResult<(S1, S2, S3, S4, S5, S6, S7, S8, NewResponse)> where Response == Result<(S1, S2, S3, S4, S5, S6, S7, S8)> {
            return parallel(a, completesOn: completionQueue, combine: { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, $1) })
    }
}
