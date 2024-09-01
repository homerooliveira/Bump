//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import XcodeProjWrapper

public final class TargetMock: Target {
    public let name: String
    public let buildConfigurations: [any BuildConfiguration]

    public init(name: String, buildConfigurations: [any BuildConfiguration]) {
        self.name = name
        self.buildConfigurations = buildConfigurations
    }
}
