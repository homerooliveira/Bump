//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import XcodeProjWrapper

final class XcodeProjWrapperMock: XcodeProjWrapperProtocol {
    var targets: [Target]
    var saveChangesCalled = false
    
    init(targets: [Target] = []) {
        self.targets = targets
    }
    
    func saveChanges() {
        saveChangesCalled = true
    }
}

extension XcodeProjWrapperMock {
    static var mock: XcodeProjWrapperMock {
        XcodeProjWrapperMock(
            targets: [
                TargetMock(
                    name: "Test1",
                    buildConfigurations: [
                        BuildConfigurationMock(
                            bundleIdentifier: "test",
                            buildNumber: "1",
                            version: "1.0"
                        )
                    ]
                ),
                TargetMock(
                    name: "Test2",
                    buildConfigurations: [
                        BuildConfigurationMock(
                            bundleIdentifier: "com.test",
                            buildNumber: "1",
                            version: "1.0"
                        )
                    ]
                )
            ]
        )
    }
}
