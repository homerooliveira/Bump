import Testing
import XCTest
import XcodeProjWrapper
import XcodeProjWrapperMock

@testable import BumpCore

struct BumpCoreTests {
    @Test func bumpBuild() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )

        var config = BuildConfiguration(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: &config, flag: .build)

        #expect(config.bundleIdentifier == "test")
        #expect(config.version == "0.0.0")
        #expect(config.buildNumber == "0.0.0.1")
    }

    @Test func bumpPatch() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )

        var config = BuildConfiguration(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: &config, flag: .patch)

        #expect(config.bundleIdentifier == "test")
        #expect(config.version == "0.0.1")
        #expect(config.buildNumber == "0.0.1.1")
    }

    @Test func bumpMinor() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )

        var config = BuildConfiguration(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: &config, flag: .minor)

        #expect(config.bundleIdentifier == "test")
        #expect(config.version == "0.1.0")
        #expect(config.buildNumber == "0.1.0.1")
    }

    @Test func bumpMajor() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )

        var config = BuildConfiguration(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: &config, flag: .major)

        #expect(config.bundleIdentifier == "test")
        #expect(config.version == "1.0.0")
        #expect(config.buildNumber == "1.0.0.1")
    }

    @Test func bumpVersionString() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )

        var config = BuildConfiguration(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: &config, flag: .versionString("1.0.0"))

        #expect(config.bundleIdentifier == "test")
        #expect(config.version == "1.0.0")
        #expect(config.buildNumber == "1.0.0.1")
    }

    @Test func bumpVersionStringWithSameVersion() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: true,
            inPlace: false
        )

        var config = BuildConfiguration(bundleIdentifier: "test", buildNumber: nil, version: nil)
        bump.applyBump(configuration: &config, flag: .versionString("1.0.0"))

        #expect(config.bundleIdentifier == "test")
        #expect(config.version == "1.0.0")
        #expect(config.buildNumber == "1.0.0.1")
    }

    @Test func bumpSetVersionWithOneDotAndIncrement() throws {
        let bump = try Bump(
            xcodeProj: XcodeProjWrapperMock(),
            bundleIdentifiers: ["test"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )

        var config = BuildConfiguration(
            bundleIdentifier: "test",
            buildNumber: "1.0",
            version: "1.0"
        )
        bump.applyBump(configuration: &config, flag: .versionString("1.0"))

        #expect(config.bundleIdentifier == "test")
        #expect(config.version == "1.0")
        #expect(config.buildNumber == "1.0")
    }

    @Test func getConfigurationsByTargetName() throws {
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

        let expected: [String: [BuildConfiguration]] = [
            "Test1": [
                BuildConfiguration(
                    bundleIdentifier: "test",
                    buildNumber: "1",
                    version: "1.0"
                )
            ]
        ]

        #expect(configByTargetName == expected)
    }
}
