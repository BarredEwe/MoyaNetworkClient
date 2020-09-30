import Moya
#if !COCOAPODS
import MoyaNC
import Foundation
#endif

extension MoyaNCError {
    static public let flatMapNil: Error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "FutureResult cannot be flatMap to nil"])
}
