private import SwiftExtensions
internal import XcodeProj
import Foundation

private enum BuildSettingKey: String {
    case version = "MARKETING_VERSION"
    case buildNumber = "CURRENT_PROJECT_VERSION"
    case identifier = "PRODUCT_BUNDLE_IDENTIFIER"
}

public struct BuildConfiguration: Equatable {
    // These properties are used to avoid dependency on XCBuildConfiguration
    let setBuildSettings: ((inout [String: Any]) -> Void) -> Void
    let getBuildSettings: () -> [String: Any]

    public var bundleIdentifier: String {
        getBuildSettings()[BuildSettingKey.identifier] as? String ?? ""
    }

    public var buildNumber: String? {
        get {
            getBuildSettings()[BuildSettingKey.buildNumber] as? String
        }
        set {
            setBuildSettings { $0[BuildSettingKey.buildNumber] = newValue }
        }
    }

    public var version: String? {
        get {
            getBuildSettings()[BuildSettingKey.version] as? String
        }
        set {
            setBuildSettings { $0[BuildSettingKey.version] = newValue }
        }
    }

    init(buildConfiguration: XCBuildConfiguration) {
        self.setBuildSettings = { closure in
            closure(&buildConfiguration.buildSettings)
        }
        self.getBuildSettings = {
            buildConfiguration.buildSettings
        }
    }

    public init(bundleIdentifier: String, buildNumber: String?, version: String?) {
        var buildSettings = [String: Any]()
        buildSettings[BuildSettingKey.identifier] = bundleIdentifier
        buildSettings[BuildSettingKey.buildNumber] = buildNumber
        buildSettings[BuildSettingKey.version] = version

        self.setBuildSettings = { closure in
            closure(&buildSettings)
        }
        self.getBuildSettings = {
            buildSettings
        }
    }

    public static func == (lhs: BuildConfiguration, rhs: BuildConfiguration) -> Bool {
        lhs.bundleIdentifier == rhs.bundleIdentifier
            && lhs.buildNumber == rhs.buildNumber
            && lhs.version == rhs.version
    }
}
