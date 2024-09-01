//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

private import XcodeProj

extension PBXNativeTarget: Target {
    public var buildConfigurations: [any BuildConfiguration] {
        buildConfigurationList?.buildConfigurations ?? []
    }
}
