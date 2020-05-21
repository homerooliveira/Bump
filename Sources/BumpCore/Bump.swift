//
//  Bumper.swift
//  
//
//  Created by Homero Oliveira on 20/02/20.
//

import Foundation
import XcodeProj
import PathKit

public struct Bump {
    private let path: Path
    private let xcodeproj: XcodeProj
    private var configsByTargetName: [String: [XCBuildConfiguration]] = [:]
    
    public init(path: String, bundleIdentifiers: Set<String>) throws {
        self.path = Path(path)
        self.xcodeproj = try XcodeProj(path: self.path)
        self.configsByTargetName = getConfigurationsByTargetName(bundleIdentifiers: bundleIdentifiers)
    }
    
    public func bump(flag: IncrementMode) throws {
        for (targetName, configs) in configsByTargetName {
            guard let config = configs.first else { continue }
            print("\(targetName) \(config.buildNumber ?? "")", terminator: "")
            applyBump(configuration: config, flag: flag)
            print(" -> \(config.buildNumber ?? "")")
            configs.dropFirst()
                .forEach { (config) in
                applyBump(configuration: config, flag: flag)
            }
        }
        
        try xcodeproj.writePBXProj(path: path, outputSettings: PBXOutputSettings())
    }
    
    private func getConfigurationsByTargetName(bundleIdentifiers: Set<String>) -> [String: [XCBuildConfiguration]] {
        var configsByTargetName: [String: [XCBuildConfiguration]] = [:]
        
        for target in xcodeproj.pbxproj.nativeTargets {
            let configurations = target.buildConfigurationList?.buildConfigurations ?? []
            
            for configuration in configurations {
                let bundleIdentifierOfConfig = configuration.bundleIdentifier
                if bundleIdentifiers.contains(where: bundleIdentifierOfConfig.starts(with:)) {
                    configsByTargetName[target.name, default: []].append(configuration)
                }
            }
        }
        
        return configsByTargetName
    }
    
    private func applyBump(configuration: XCBuildConfiguration, flag: IncrementMode) {
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
            versionNumbers[2] = "\(patch + 1)"
        }
    }
    
    private func changeVersionsNumbers(configuration: XCBuildConfiguration, transform: (inout [Substring]) -> Void) {
        var versions = configuration.version.map { $0.split(separator: ".") } ?? ["0", "0", "0"]
        transform(&versions)
        let version = versions.joined(separator: ".")
        configuration.version = version
        configuration.buildNumber = "\(version).1"
    }
    
    private func bumpBuildVersion(configuration: XCBuildConfiguration) {
        let buildNumber = configuration.buildNumber?
            .split(separator: ".")
            .last
            .map(String.init)
            .flatMap(Int.init) ?? 0
        configuration.buildNumber = "\(configuration.version ?? "0.0.0").\(buildNumber + 1)"
    }
}
