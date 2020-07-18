//
//  Bumper.swift
//  
//
//  Created by Homero Oliveira on 20/02/20.
//

import Foundation
import XcodeProjWrapper
import SwiftExtensions

public struct Bump {
    private let xcodeProj: XcodeProjWrapperProtocol
    private let bundleIdentifiers: Set<String>
    private let log: (String) -> Void
    
    public init(xcodeProj: XcodeProjWrapperProtocol, bundleIdentifiers: Set<String>, log: @escaping (String) -> Void) throws {
        self.xcodeProj = xcodeProj
        self.bundleIdentifiers = bundleIdentifiers
        self.log = log
    }
    
    public func bump(flag: IncrementMode) throws {
        let configsByTargetName: [String: [BuildConfiguration]] = getConfigurationsByTargetName(bundleIdentifiers: bundleIdentifiers)
        
        for (targetName, configs) in configsByTargetName {
            guard let config = configs.first else { continue }
            var targetOutput = "\(targetName) \(config.buildNumber ?? "")"
            applyBump(configuration: config, flag: flag)
            targetOutput += " -> \(config.buildNumber ?? "")"
            log(targetOutput)
            for config in configs.dropFirst() {
                applyBump(configuration: config, flag: flag)
            }
        }
        
        try xcodeProj.saveChanges()
    }
    
    func getConfigurationsByTargetName(bundleIdentifiers: Set<String>) -> [String : [BuildConfiguration]] {
        var configsByTargetName: [String: [BuildConfiguration]] = [:]
        
        for target in xcodeProj.targets {
            let configurations = target.buildConfigurations ?? []
            
            for configuration in configurations {
                let bundleIdentifierOfConfig = configuration.bundleIdentifier
                if bundleIdentifiers.contains(where: bundleIdentifierOfConfig.starts(with:))
                    || bundleIdentifiers.contains("all") {
                    configsByTargetName[target.name, default: []].append(configuration)
                }
            }
        }
        
        return configsByTargetName
    }
    
    func applyBump(configuration: BuildConfiguration, flag: IncrementMode) {
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
    
    private func bumpMajorVersion(configuration: BuildConfiguration) {
        changeVersionsNumbers(configuration: configuration) { (versionNumbers) in
            let major = Int(versionNumbers[VersionIndex.major]) ?? 0
            versionNumbers[VersionIndex.major] = "\(major + 1)"
            versionNumbers[VersionIndex.minor] = "0"
            versionNumbers[VersionIndex.patch] = "0"
        }
    }
    
    private func bumpMinorVersion(configuration: BuildConfiguration) {
        changeVersionsNumbers(configuration: configuration) { (versionNumbers) in
            let minor = Int(versionNumbers[VersionIndex.minor]) ?? 0
            versionNumbers[VersionIndex.minor] = "\(minor + 1)"
            versionNumbers[VersionIndex.patch] = "0"
        }
    }
    
    private func bumpPatchVersion(configuration: BuildConfiguration) {
        changeVersionsNumbers(configuration: configuration) { (versionNumbers) in
            let patch = Int(versionNumbers[VersionIndex.patch]) ?? 0
            versionNumbers[VersionIndex.patch] = "\(patch + 1)"
        }
    }
    
    private func changeVersionsNumbers(configuration: BuildConfiguration, transform: (inout [Substring]) -> Void) {
        var versionArray: [Substring] = getVersion(using: configuration)
        transform(&versionArray)
        let version = versionArray.joined(separator: ".")
        configuration.version = version
        configuration.buildNumber = "\(version).1"
    }
    
    private func bumpBuildVersion(configuration: BuildConfiguration) {
        let version = getVersion(using: configuration).joined(separator: ".")
        let buildNumber = configuration.buildNumber?
            .split(separator: ".")
            .last
            .map(String.init)
            .flatMap(Int.init) ?? 0
        configuration.version = version
        configuration.buildNumber = "\(version).\(buildNumber + 1)"
    }
    
    private func getVersion(using configuration: BuildConfiguration) -> [Substring] {
        if let version = configuration.version?.split(separator: ".") {
            if version.count == 3 {
                return version
            } else {
                return version + Array(repeating: "0", count: 3 - version.count)
            }
        } else {
            return ["0", "0", "0"]
        }
    }
}
