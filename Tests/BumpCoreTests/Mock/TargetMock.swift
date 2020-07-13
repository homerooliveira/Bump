//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import XcodeProjWrapper

final class TargetMock: Target {
    var name: String
    var buildConfigurations: [BuildConfiguration]?
    
    init(name: String, buildConfigurations: [BuildConfiguration]?) {
        self.name = name
        self.buildConfigurations = buildConfigurations
    }
    
}
