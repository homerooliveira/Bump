//
//  File.swift
//  
//
//  Created by Homero Oliveira on 08/07/20.
//

import XCTest
import XcodeProjWrapperMock

@testable import BumpCore

final class BumpCoreTests: XCTestCase {

    func testBumpBuild() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )
        
        let config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: config, flag: .build)

        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "0.0.0")
        XCTAssertEqual(config.buildNumber, "0.0.0.1")
    }

    func testBumpPatch() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )
        
        let config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: config, flag: .patch)

        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "0.0.1")
        XCTAssertEqual(config.buildNumber, "0.0.1.1")
    }

    func testBumpMinor() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )
        
        let config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: config, flag: .minor)

        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "0.1.0")
        XCTAssertEqual(config.buildNumber, "0.1.0.1")
    }

    func testBumpMajor() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )
        
        let config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: config, flag: .major)

        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "1.0.0")
        XCTAssertEqual(config.buildNumber, "1.0.0.1")
    }

    func testBumpSetVersionWithThreeDots() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )
        
        let config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: config, flag: .versionString("1.0.0"))

        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "1.0.0")
        XCTAssertEqual(config.buildNumber, "1.0.0.1")
    }

    func testBumpSetVersion() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )
        
        let config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: config, flag: .versionString("1.0.0.3"))

        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "1.0.0")
        XCTAssertEqual(config.buildNumber, "1.0.0.3")
    }

    func testGetConfigurationsByTargetName() throws {
        let xcodeProj = XcodeProjWrapperMock.mock
        let bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )
        
        let configByTargetName = bump.getConfigurationsByTargetName() as? [String: [BuildConfigurationMock]]

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

    func testGetConfigurationsByTargetNameWithAllAsBundleIdentifier() throws {
        let xcodeProj = XcodeProjWrapperMock.mock
        let bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["all"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )
        
        let configByTargetName = bump.getConfigurationsByTargetName() as? [String: [BuildConfigurationMock]]

        let expected: [String: [BuildConfigurationMock]] = [
            "Test1": [
                BuildConfigurationMock(
                    bundleIdentifier: "test",
                    buildNumber: "1",
                    version: "1.0"
                )
            ],
            "Test2": [
                BuildConfigurationMock(
                    bundleIdentifier: "com.test",
                    buildNumber: "1",
                    version: "1.0"
                )
            ]
        ]

        XCTAssertEqual(configByTargetName, expected)
        XCTAssertEqual(configByTargetName?.count, 2)
    }

    func testBumpOutputVerbose() throws {
        var logs: [String] = []
        let xcodeProj = XcodeProjWrapperMock.mock
        let bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["com.test"],
            log: { logs.append($0) },
            isVerbose: true,
            useSameVersion: false,
            inPlace: true
        )

        try bump.bump(flag: .minor)

        XCTAssertEqual(logs, ["Test2 1 -> 1.1.0.1"])
        XCTAssertEqual(logs.count, 1)
        XCTAssertTrue(xcodeProj.saveChangesCalled)
    }

    func testBumpOutput() throws {
        var logs: [String] = []
        let xcodeProj = XcodeProjWrapperMock.mock
        let bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["com.test"],
            log: { logs.append($0) },
            isVerbose: false,
            useSameVersion: false,
            inPlace: true
        )

        try bump.bump(flag: .minor)

        XCTAssertEqual(logs, ["1.1.0.1"])
        XCTAssertEqual(logs.count, 1)
        XCTAssertTrue(xcodeProj.saveChangesCalled)
    }

    func testBumpOutputSameVersionEnabled() throws {
        var logs: [String] = []
        let xcodeProj = XcodeProjWrapperMock.mockWithThreeConfigs
        let bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["com.test"],
            log: { logs.append($0) },
            isVerbose: false,
            useSameVersion: true,
            inPlace: true
        )

        try bump.bump(flag: .minor)

        XCTAssertEqual(logs, ["1.1.0.1"])
        XCTAssertEqual(logs.count, 1)
        XCTAssertTrue(xcodeProj.saveChangesCalled)
    }

    func testBumpOutputSameVersionEnabledAndVerbose() throws {
        var logs: [String] = []
        let xcodeProj = XcodeProjWrapperMock.mock
        let bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["com.test"],
            log: { logs.append($0) },
            isVerbose: true,
            useSameVersion: true,
            inPlace: true
        )

        try bump.bump(flag: .minor)

        XCTAssertEqual(logs, ["Test2", "1 -> 1.1.0.1"])
        XCTAssertEqual(logs.count, 2)
        XCTAssertTrue(xcodeProj.saveChangesCalled)
    }

    func testBumpOutputVersionUnsureVersionHasThreeElements() throws {
        let xcodeProj = XcodeProjWrapperMock(
            targets: [
                TargetMock(
                    name: "Test1",
                    buildConfigurations: [
                        BuildConfigurationMock(
                            bundleIdentifier: "test",
                            buildNumber: "1",
                            version: "1.0.0.1.1"
                        )
                    ]
                )
            ]
        )
        var logs: [String] = []

        let bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["test"],
            log: { logs.append($0) },
            isVerbose: true,
            useSameVersion: false,
            inPlace: true
        )

        try bump.bump(flag: .build)

        XCTAssertEqual(logs, ["Test1 1 -> 1.0.0.2"])
        XCTAssertEqual(logs.count, 1)
        XCTAssertTrue(xcodeProj.saveChangesCalled)
    }
    
    func testBumpOutputVerboseWhenInPlaceIsTrue() throws {
        var logs: [String] = []
        let xcodeProj = XcodeProjWrapperMock.mock
        let bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["com.test"],
            log: { logs.append($0) },
            isVerbose: true,
            useSameVersion: false,
            inPlace: false
        )
        
        try bump.bump(flag: .minor)
        
        XCTAssertEqual(logs, ["Test2 1 -> 1.1.0.1"])
        XCTAssertEqual(logs.count, 1)
        XCTAssertFalse(xcodeProj.saveChangesCalled)
    }
    
    func testBumpOutputVersionWithTwoBuildConfigs() throws {
        let xcodeProj = XcodeProjWrapperMock(
            targets: [
                TargetMock(
                    name: "Test1",
                    buildConfigurations: [
                        BuildConfigurationMock(
                            bundleIdentifier: "test",
                            buildNumber: "1",
                            version: "1.0.0.1"
                        ),
                        BuildConfigurationMock(
                            bundleIdentifier: "test",
                            buildNumber: "1",
                            version: "1.0.0.1"
                        )
                    ]
                )
            ]
        )
        var logs: [String] = []
        
        let bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["test"],
            log: { string in
                logs.append(string)
            },
            isVerbose: true,
            useSameVersion: false,
            inPlace: false
        )
        
        try bump.bump(flag: .build)
        
        XCTAssertEqual(
            logs,
            ["Test1 1 -> 1.0.0.2"]
        )
        XCTAssertEqual(logs.count, 1)
        XCTAssertFalse(xcodeProj.saveChangesCalled)
    }
}
