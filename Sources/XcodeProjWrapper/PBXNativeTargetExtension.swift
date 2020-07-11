//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import XcodeProj

extension PBXNativeTarget: Target {
    public var buildConfigurations: [BuildConfiguration]? {
        buildConfigurationList?.buildConfigurations
    }
}
