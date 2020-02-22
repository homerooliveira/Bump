//
//  XCBuildConfigurationExtension.swift
//  
//
//  Created by Homero Oliveira on 20/02/20.
//

import Foundation
import XcodeProj

enum BuildSettingKey: String {
    case version = "MARKETING_VERSION"
    case buildNumber = "CURRENT_PROJECT_VERSION"
    case identifier = "PRODUCT_BUNDLE_IDENTIFIER"
}

extension XCBuildConfiguration {
    
    var bundleIdentifier: String {
        get {
            (buildSettings[BuildSettingKey.identifier.rawValue] as? String) ?? ""
        }
        set {
            buildSettings[BuildSettingKey.identifier.rawValue] = newValue
        }
    }
    
    var buildNumber: String? {
        get {
            buildSettings[BuildSettingKey.buildNumber.rawValue] as? String
        }
        set {
            buildSettings[BuildSettingKey.buildNumber.rawValue] = newValue
        }
    }
    
    var version: String? {
        get {
            buildSettings[BuildSettingKey.version.rawValue] as? String
        }
        set {
            buildSettings[BuildSettingKey.version.rawValue] = newValue
        }
    }
}
