private import SwiftExtensions
internal import XcodeProj
import Foundation

private enum BuildSettingKey: String {
    case version = "MARKETING_VERSION"
    case buildNumber = "CURRENT_PROJECT_VERSION"
    case identifier = "PRODUCT_BUNDLE_IDENTIFIER"
}

public struct BuildConfiguration: Equatable {
    let buildConfiguration: XCBuildConfiguration

    public var bundleIdentifier: String {
        (buildConfiguration.buildSettings[BuildSettingKey.identifier] as? String) ?? ""
    }

    public var buildNumber: String? {
        get {
            buildConfiguration.buildSettings[BuildSettingKey.buildNumber] as? String
        }
        set {
            buildConfiguration.buildSettings[BuildSettingKey.buildNumber] = newValue
        }
    }

    public var version: String? {
        get {
            buildConfiguration.buildSettings[BuildSettingKey.version] as? String
        }
        set {
            buildConfiguration.buildSettings[BuildSettingKey.version] = newValue
        }
    }

    init(buildConfiguration: XCBuildConfiguration) {
        self.buildConfiguration = buildConfiguration
    }

    public init(bundleIdentifier: String, buildNumber: String?, version: String?) {
        var buildSettings: BuildSettings = [
            BuildSettingKey.identifier.rawValue: bundleIdentifier
        ]
        buildSettings[BuildSettingKey.buildNumber.rawValue] = buildNumber
        buildSettings[BuildSettingKey.version.rawValue] = version
        self.buildConfiguration = XCBuildConfiguration(
            name: "name", 
            baseConfiguration: PBXFileReference(), 
            buildSettings: buildSettings
        )
    }

    public static func == (lhs: BuildConfiguration, rhs: BuildConfiguration) -> Bool {
        lhs.bundleIdentifier == rhs.bundleIdentifier
            && lhs.buildNumber == rhs.buildNumber
            && lhs.version == rhs.version
    }
}
