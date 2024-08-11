import XcodeProjWrapperMock
import XCTest

@testable import BumpCore

final class BumpCoreTests2: XCTestCase {
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
