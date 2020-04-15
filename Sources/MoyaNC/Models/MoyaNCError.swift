import Foundation

public struct MoyaNCError: Error, Codable {
    let error: String
}

extension MoyaNCError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(error, comment: "MoyaNC error")
    }
}
