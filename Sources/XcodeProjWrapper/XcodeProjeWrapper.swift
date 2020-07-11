//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import Foundation
import PathKit
import XcodeProj
import XcodeProjWrapperInterface

public final class XcodeProjWrapper: XcodeProjWrapperProtocol {
    
    private let path: Path
    private let xcodeProj: XcodeProj
    
    public init(path: String) throws {
        self.path = Path(path)
        self.xcodeProj = try XcodeProj(path: self.path)
    }
    
    public func getConfigurationsByTargetName(bundleIdentifiers: Set<String>) -> [String : [BuildConfiguration]] {
        var configsByTargetName: [String: [BuildConfiguration]] = [:]
        
        for target in xcodeProj.pbxproj.nativeTargets {
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
    
    public func saveChanges() throws {
        try xcodeProj.writePBXProj(path: path, outputSettings: PBXOutputSettings())
    }
    
}
