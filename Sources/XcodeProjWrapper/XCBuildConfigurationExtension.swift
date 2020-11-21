//
//  XCBuildConfigurationExtension.swift
//  
//
//  Created by Homero Oliveira on 20/02/20.
//

import Foundation
import SwiftExtensions
import XcodeProj

private enum BuildSettingKey: String {
    case version = "MARKETING_VERSION"
    case buildNumber = "CURRENT_PROJECT_VERSION"
    case identifier = "PRODUCT_BUNDLE_IDENTIFIER"
}

extension XCBuildConfiguration: BuildConfiguration {

    public var bundleIdentifier: String {
        (buildSettings[BuildSettingKey.identifier] as? String) ?? ""
    }

    public var buildNumber: String? {
        get {
            buildSettings[BuildSettingKey.buildNumber] as? String
        }
        set {
            buildSettings[BuildSettingKey.buildNumber] = newValue
        }
    }

    public var version: String? {
        get {
            buildSettings[BuildSettingKey.version] as? String
        }
        set {
            buildSettings[BuildSettingKey.version] = newValue
        }
    }
}
