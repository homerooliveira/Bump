//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import XcodeProjWrapper

final class BuildConfigurationMock: BuildConfiguration, Equatable {
    var bundleIdentifier: String
    var buildNumber: String?
    var version: String?
    
    init(bundleIdentifier: String, buildNumber: String?, version: String?) {
        self.bundleIdentifier = bundleIdentifier
        self.buildNumber = buildNumber
        self.version = version
    }
}

func == (lhs: BuildConfigurationMock, rhs: BuildConfigurationMock) -> Bool {
    lhs.bundleIdentifier == rhs.bundleIdentifier
        && lhs.buildNumber == rhs.buildNumber
        && lhs.version == rhs.version
}
