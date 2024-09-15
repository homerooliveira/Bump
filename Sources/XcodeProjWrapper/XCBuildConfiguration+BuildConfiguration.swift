private import SwiftExtensions
internal import XcodeProj
import Foundation

private enum BuildSettingKey: String {
    case version = "MARKETING_VERSION"
    case buildNumber = "CURRENT_PROJECT_VERSION"
    case identifier = "PRODUCT_BUNDLE_IDENTIFIER"
}

struct BuildConfigurationWrapper: BuildConfiguration {
    let buildConfiguration: XCBuildConfiguration

    var bundleIdentifier: String {
        (buildConfiguration.buildSettings[BuildSettingKey.identifier] as? String) ?? ""
    }

    var buildNumber: String? {
        get {
            buildConfiguration.buildSettings[BuildSettingKey.buildNumber] as? String
        }
        set {
            buildConfiguration.buildSettings[BuildSettingKey.buildNumber] = newValue
        }
    }

    var version: String? {
        get {
            buildConfiguration.buildSettings[BuildSettingKey.version] as? String
        }
        set {
            buildConfiguration.buildSettings[BuildSettingKey.version] = newValue
        }
    }
}
