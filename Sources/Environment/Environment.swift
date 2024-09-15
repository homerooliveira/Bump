import FileManagerWrapper
import Foundation
import XcodeProjWrapper

// This struct is used to inject dependencies in the BumpCommand.
// It is safe to use @unchecked Sendable because the properties are immutable.
public struct Environment: @unchecked Sendable {
    public let xcodeProjFinder: any XcodeProjFinderProtocol
    public let xcodeProjWrapper: (String) throws -> any XcodeProjWrapperProtocol
    public let logger: (String) -> Void

    public init(
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
    public static let live = Self(
        xcodeProjFinder: XcodeProjFinder(),
        xcodeProjWrapper: { try XcodeProjWrapper(path: $0) },
        logger: { print($0) }
    )
}

// This extension is necessary to make Environment to be used in the BumpCommand as injected dependency.
extension Environment: Decodable {
    public init(from decoder: any Decoder) throws {
        self = Self.live
    }
}
