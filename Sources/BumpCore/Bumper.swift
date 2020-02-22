//
//  Bumper.swift
//  
//
//  Created by Homero Oliveira on 20/02/20.
//

import Foundation
import XcodeProj
import PathKit

public struct Bumper {
    private let path: Path
    private let xcodeproj: XcodeProj
    private var configsByTargetName: [String: [XCBuildConfiguration]] = [:]
    
    public init(path: String, bundleIdentifierPattern: String) throws {
        self.path = Path(path)
        self.xcodeproj = try XcodeProj(path: self.path)
        self.configsByTargetName = getConfigurationsByTargetName(bundleIdentifierPattern: bundleIdentifierPattern)
    }
    
    public func bump(flag: VersionArgs) throws {
        for (targetName, configs) in configsByTargetName {
            print(targetName)
            for config in configs {
                print("     \(config.name) \(config.version ?? "").\(config.buildNumber ?? "")",
                    terminator: "")
                applyBump(configuration: config, flag: flag)
                print(" -> \(config.version ?? "").\(config.buildNumber ?? "")")
            }
            print()
        }
        
        try xcodeproj.writePBXProj(path: path, outputSettings: PBXOutputSettings())
    }
    
    private func getConfigurationsByTargetName(bundleIdentifierPattern: String) -> [String: [XCBuildConfiguration]] {
        var configsByTargetName: [String: [XCBuildConfiguration]] = [:]
        
        for target in xcodeproj.pbxproj.nativeTargets {
            let configurations = target.buildConfigurationList?.buildConfigurations ?? []
            
            for configuration in configurations {
                if configuration.bundleIdentifier.starts(with: bundleIdentifierPattern) {
                    configsByTargetName[target.name, default: []].append(configuration)
                }
            }
        }
        
        return configsByTargetName
    }
    
    private func applyBump(configuration: XCBuildConfiguration, flag: VersionArgs) {
        switch flag {
        case .major:
            bumpMajorVersion(configuration: configuration)
        case .minor:
            bumpMinorVersion(configuration: configuration)
        case .patch:
            bumpPatchVersion(configuration: configuration)
        case .build:
            bumpBuildVersion(configuration: configuration)
        }
    }
    
    private func bumpMajorVersion(configuration: XCBuildConfiguration) {
        changeVersionsNumbers(configuration: configuration) { (versionNumbers) in
            let major = Int(versionNumbers[0]) ?? 0
            versionNumbers[0] = "\(major + 1)"
            versionNumbers[1] = "0"
            versionNumbers[2] = "0"
        }
    }
    
    private func bumpMinorVersion(configuration: XCBuildConfiguration) {
        changeVersionsNumbers(configuration: configuration) { (versionNumbers) in
            let minor = Int(versionNumbers[1]) ?? 0
            versionNumbers[1] = "\(minor + 1)"
            versionNumbers[2] = "0"
        }
    }
    
    private func bumpPatchVersion(configuration: XCBuildConfiguration) {
        changeVersionsNumbers(configuration: configuration) { (versionNumbers) in
            let patch = Int(versionNumbers[2]) ?? 0
            versionNumbers[2] = "\( patch + 1)"
        }
    }
    
    private func changeVersionsNumbers(configuration: XCBuildConfiguration, transform: (inout [Substring]) -> Void) {
        var versions = configuration.version.map { $0.split(separator: ".") } ?? ["0", "0", "0"]
        transform(&versions)
        configuration.version = versions.joined(separator: ".")
        configuration.buildNumber = "1"
    }
    
    private func bumpBuildVersion(configuration: XCBuildConfiguration) {
        let buildNumber = configuration.buildNumber.flatMap(Int.init) ?? 0 + 1
        configuration.buildNumber = String(describing: buildNumber)
    }
}
