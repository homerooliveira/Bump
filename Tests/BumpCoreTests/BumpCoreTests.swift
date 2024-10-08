internal import XcodeProjWrapperMock
import XCTest

@testable internal import BumpCore

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

        var config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: &config, flag: .build)

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

        var config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: &config, flag: .patch)

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

        var config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: &config, flag: .minor)

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

        var config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: &config, flag: .major)

        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "1.0.0")
        XCTAssertEqual(config.buildNumber, "1.0.0.1")
    }

    func testBumpSetVersionWithTwoDots() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )

        var config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: &config, flag: .versionString("1.0.0"))

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

        var config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: &config, flag: .versionString("1.0.0.3"))

        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "1.0.0")
        XCTAssertEqual(config.buildNumber, "1.0.0.3")
    }

    func testBumpSetVersionWithOneDotAndIncrement() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )

        var config = BuildConfigurationMock(bundleIdentifier: "test", buildNumber: "1.0", version: "1.0")
        bump.applyBump(configuration: &config, flag: .versionString("1.0"))

        XCTAssertEqual(config.bundleIdentifier, "test")
        XCTAssertEqual(config.version, "1.0")
        XCTAssertEqual(config.buildNumber, "1.0")
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

        let configByTargetName = bump.getConfigurationsByTargetName()

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
    }
}
