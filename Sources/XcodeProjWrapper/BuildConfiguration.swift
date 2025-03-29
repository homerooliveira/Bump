private import SwiftExtensions
import XcodeProj
import Foundation

private enum BuildSettingKey: String {
    case version = "MARKETING_VERSION"
    case buildNumber = "CURRENT_PROJECT_VERSION"
    case identifier = "PRODUCT_BUNDLE_IDENTIFIER"
}

package struct BuildConfiguration: Equatable {
    // These properties are used to avoid dependency on XCBuildConfiguration
    let setBuildSettings: (String, String) -> Void
    let getBuildSettings: (String) -> String?

    package var bundleIdentifier: String {
        get { getBuildSettings(BuildSettingKey.identifier.rawValue) ?? "" }
    }

    package var buildNumber: String? {
        get {
            getBuildSettings(BuildSettingKey.buildNumber.rawValue)
        }
        set {
            setBuildSettings(BuildSettingKey.buildNumber.rawValue, newValue ?? "")
        }
    }

    package var version: String? {
        get {
            getBuildSettings(BuildSettingKey.version.rawValue)
        }
        set {
            setBuildSettings(BuildSettingKey.version.rawValue, newValue ?? "")
        }
    }

    init(buildConfiguration: XCBuildConfiguration) {
        self.setBuildSettings = { key, value in
            buildConfiguration.buildSettings[key] = .string(value)
        }
        self.getBuildSettings = { key in
            buildConfiguration.buildSettings[key]?.stringValue
        }
    }

    package init(bundleIdentifier: String, buildNumber: String?, version: String?) {
        var buildSettings = [String: Any]()
        buildSettings[BuildSettingKey.identifier] = bundleIdentifier
        buildSettings[BuildSettingKey.buildNumber] = buildNumber
        buildSettings[BuildSettingKey.version] = version

        self.setBuildSettings = { key, value in
            buildSettings[key] = value
        }
        self.getBuildSettings = { key in
            buildSettings[key] as? String
        }
    }

    package static func == (lhs: BuildConfiguration, rhs: BuildConfiguration) -> Bool {
        lhs.bundleIdentifier == rhs.bundleIdentifier
            && lhs.buildNumber == rhs.buildNumber
            && lhs.version == rhs.version
    }
}
