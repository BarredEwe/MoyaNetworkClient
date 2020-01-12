import Foundation

/// Type of interaction with cached responses
public enum MoyaCachePolicy: UInt {
    case reloadIgnoringCacheData
    case returnCacheDataElseLoad
    case returnCacheDataDontLoad
    case notUseCache
}
