import Foundation
import XcodeProjWrapper

public final class BuildConfigurationMock: BuildConfiguration {
    public var bundleIdentifier: String
    public var buildNumber: String?
    public var version: String?

    public init(bundleIdentifier: String, buildNumber: String?, version: String?) {
        self.bundleIdentifier = bundleIdentifier
        self.buildNumber = buildNumber
        self.version = version
    }
}

extension BuildConfigurationMock: Equatable {
    public static func == (lhs: BuildConfigurationMock, rhs: BuildConfigurationMock) -> Bool {
        lhs.bundleIdentifier == rhs.bundleIdentifier
            && lhs.buildNumber == rhs.buildNumber
            && lhs.version == rhs.version
    }
}
