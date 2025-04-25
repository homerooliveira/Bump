import FileManagerWrapper
import Foundation
import XcodeProjWrapper

// This struct is used to inject dependencies in the BumpCommand.
// It is safe to use @unchecked Sendable because the properties are immutable.
struct Environment: @unchecked Sendable {
    let xcodeProjFinder: any XcodeProjFinderProtocol
    let xcodeProjWrapper: (String) throws -> any XcodeProjWrapperProtocol
    let logger: (String) -> Void
}

extension Environment {
    static let live = Self(
        xcodeProjFinder: XcodeProjFinder(fileManagerWrapper: FileManager.default),
        xcodeProjWrapper: { try XcodeProjWrapper(path: $0) },
        logger: { print($0) }
    )
}

// This extension is necessary to make Environment to be used in the BumpCommand as injected dependency.
extension Environment: Decodable {
    init(from decoder: any Decoder) throws {
        self = Self.live
    }
}
