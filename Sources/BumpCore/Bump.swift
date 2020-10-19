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
    private let isVerbose: Bool
    private let useSameVersion: Bool
    
    public init(
        xcodeProj: XcodeProjWrapperProtocol,
        bundleIdentifiers: Set<String>,
        log: @escaping (String) -> Void,
        isVerbose: Bool = false,
        useSameVersion: Bool = false
    ) throws {
        self.xcodeProj = xcodeProj
        self.bundleIdentifiers = bundleIdentifiers
        self.log = log
        self.isVerbose = isVerbose
        self.useSameVersion = useSameVersion
    }
    
    public func bump(flag: IncrementMode) throws {
        let configsByTargetName = getConfigurationsByTargetName()
        
        if useSameVersion {
            let configs = configsByTargetName.values
                .lazy
                .flatMap { $0 }
            
            guard let config = configs.first else { return }
            
            let oldBuildNumber = config.buildNumber ?? ""
            applyBump(configuration: config, flag: flag)
            let buildNumber = config.buildNumber ?? ""
            
            if isVerbose {
                let allTargets = configsByTargetName.keys.joined(separator: ", ")
                log(allTargets)
                log("\(oldBuildNumber) -> \(buildNumber)")
            } else {
                log(buildNumber)
            }
            
            let versionFlag: IncrementMode = .versionString(buildNumber)
            
            for config in configs.dropFirst() {
                applyBump(configuration: config, flag: versionFlag)
            }
        } else {
            for (targetName, configs) in configsByTargetName {
                guard let config = configs.first else { continue }
                
                let oldBuildNumber = config.buildNumber
                applyBump(configuration: config, flag: flag)
                
                if isVerbose {
                    let targetOutput = "\(targetName) \(oldBuildNumber ?? "") -> \(config.buildNumber ?? "")"
                    log(targetOutput)
                } else if let buildNumber = config.buildNumber {
                    log(buildNumber)
                }
                
                for config in configs.dropFirst() {
                    applyBump(configuration: config, flag: flag)
                }
            }
        }
        
        try xcodeProj.saveChanges()
    }
    
    func getConfigurationsByTargetName() -> [String : [BuildConfiguration]] {
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
        case .versionString(let version):
            setVersions(version: version, configuration: configuration)
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
            if version.count >= 3 {
                return version
            } else {
                return version + Array(repeating: "0", count: 3 - version.count)
            }
        } else {
            return ["0", "0", "0"]
        }
    }
    
    private func setVersions(version: String, configuration: BuildConfiguration) {
        let versionArray = version.split(separator: ".")
        
        if versionArray.count == 3 {
            configuration.version = version
            configuration.buildNumber = version + ".1"
        } else if versionArray.count == 4 {
            configuration.version = versionArray.dropLast().joined(separator: ".")
            configuration.buildNumber = version
        }
    }
}
