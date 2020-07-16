//
//  File.swift
//  
//
//  Created by Homero Oliveira on 08/07/20.
//

import XCTest
import XcodeProjWrapper

@testable import BumpCore

final class BumpTests: XCTestCase {
    
    func testBumpBuild() throws {
        let bump = try Bump(xcodeProj: XcodeProjWrapperMock(), bundleIdentifiers: ["test"])
        
        let config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: config, flag: .build)
        
        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "0.0.0")
        XCTAssertEqual(config.buildNumber, "0.0.0.1")
    }
    
    func testBumpPatch() throws {
        let bump = try Bump(xcodeProj: XcodeProjWrapperMock(), bundleIdentifiers: ["test"])
        
        let config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: config, flag: .patch)
        
        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "0.0.1")
        XCTAssertEqual(config.buildNumber, "0.0.1.1")
    }
    
    func testBumpMinor() throws {
        let bump = try Bump(xcodeProj: XcodeProjWrapperMock(), bundleIdentifiers: ["test"])
        
        let config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: config, flag: .minor)
        
        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "0.1.0")
        XCTAssertEqual(config.buildNumber, "0.1.0.1")
    }
    
    func testBumpMajor() throws {
        let bump = try Bump(xcodeProj: XcodeProjWrapperMock(), bundleIdentifiers: ["test"])
        
        let config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: config, flag: .major)
        
        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "1.0.0")
        XCTAssertEqual(config.buildNumber, "1.0.0.1")
    }
    
    func testGetConfigurationsByTargetName() throws {
        let xcodeProj = XcodeProjWrapperMock(
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
        
        let bump = try Bump(xcodeProj: xcodeProj, bundleIdentifiers: ["test"])
        let configByTargetName = bump.getConfigurationsByTargetName(bundleIdentifiers: ["test"]) as? [String: [BuildConfigurationMock]]
        
        let expected: [String: [BuildConfigurationMock]] = [
            "Test1": [
                BuildConfigurationMock(
                    bundleIdentifier: "test",
                    buildNumber: "1",
                    version: "1.0"
                )
            ]
        ]
        
        XCTAssertEqual(configByTargetName, expected)
        XCTAssertEqual(configByTargetName?.count, 1)
    }
}