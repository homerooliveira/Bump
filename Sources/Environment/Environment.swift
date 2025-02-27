package import FileManagerWrapper
import Foundation
package import XcodeProjWrapper

// This struct is used to inject dependencies in the BumpCommand.
// It is safe to use @unchecked Sendable because the properties are immutable.
package struct Environment: @unchecked Sendable {
    package let xcodeProjFinder: any XcodeProjFinderProtocol
    package let xcodeProjWrapper: (String) throws -> any XcodeProjWrapperProtocol
    package let logger: (String) -> Void

    package init(
        xcodeProjFinder: any XcodeProjFinderProtocol,
        xcodeProjWrapper: @escaping (String) throws -> any XcodeProjWrapperProtocol,
        logger: @escaping (String) -> Void
    ) {
        self.xcodeProjFinder = xcodeProjFinder
        self.xcodeProjWrapper = xcodeProjWrapper
        self.logger = logger
    }
}

extension Environment {
    package static let live = Self(
        xcodeProjFinder: XcodeProjFinder(fileManagerWrapper: FileManager.default),
        xcodeProjWrapper: { try XcodeProjWrapper(path: $0) },
        logger: { print($0) }
    )
}

// This extension is necessary to make Environment to be used in the BumpCommand as injected dependency.
extension Environment: Decodable {
    package init(from decoder: any Decoder) throws {
        self = Self.live
    }
}
