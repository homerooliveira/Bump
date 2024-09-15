import Foundation
import XcodeProjWrapper

public struct BuildConfigurationMock: BuildConfiguration, Equatable {
    public var bundleIdentifier: String
    public var buildNumber: String?
    public var version: String?

    public init(bundleIdentifier: String, buildNumber: String?, version: String?) {
        self.bundleIdentifier = bundleIdentifier
        self.buildNumber = buildNumber
        self.version = version
    }
}
