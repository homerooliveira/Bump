import Testing
import XcodeProjWrapperMock

@testable import BumpCore

struct BumpCoreTests2 {
    @Test func getConfigurationsByTargetNameWithAllAsBundleIdentifier() throws {
        let xcodeProj = XcodeProjWrapperMock.mock
        let bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["all"],
            log: { _ in },
            isVerbose: false,
            useSameVersion: false,
            inPlace: false
        )

        let configByTargetName = bump.getConfigurationsByTargetName()

        let expected = [
            "Test1": [
                BuildConfiguration(
                    bundleIdentifier: "test",
                    buildNumber: "1",
                    version: "1.0"
                )
            ],
            "Test2": [
                BuildConfiguration(
                    bundleIdentifier: "com.test",
                    buildNumber: "1",
                    version: "1.0"
                )
            ]
        ]

        #expect(configByTargetName == expected)
        #expect(configByTargetName.count == 2)
    }

    @Test func bumpOutputVerbose() throws {
        var logs: [String] = []
        let xcodeProj = XcodeProjWrapperMock.mock
        var bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["com.test"],
            log: { logs.append($0) },
            isVerbose: true,
            useSameVersion: false,
            inPlace: true
        )

        try bump.bump(flag: .minor)

        #expect(logs == ["Test2 1 -> 1.1.0.1"])
        #expect(logs.count == 1)
        #expect(xcodeProj.saveChangesCalled)
    }

    @Test func bumpOutput() throws {
        var logs: [String] = []
        let xcodeProj = XcodeProjWrapperMock.mock
        var bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["com.test"],
            log: { logs.append($0) },
            isVerbose: false,
            useSameVersion: false,
            inPlace: true
        )

        try bump.bump(flag: .minor)

        #expect(logs == ["1.1.0.1"])
        #expect(logs.count == 1)
        #expect(xcodeProj.saveChangesCalled)
    }

    @Test func bumpOutputSameVersionEnabled() throws {
        var logs: [String] = []
        let xcodeProj = XcodeProjWrapperMock.mockWithThreeConfigs
        var bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["com.test"],
            log: { logs.append($0) },
            isVerbose: false,
            useSameVersion: true,
            inPlace: true
        )

        try bump.bump(flag: .minor)

        #expect(logs == ["1.1.0.1"])
        #expect(logs.count == 1)
        #expect(xcodeProj.saveChangesCalled)
    }

    @Test func bumpOutputSameVersionEnabledAndVerbose() throws {
        var logs: [String] = []
        let xcodeProj = XcodeProjWrapperMock.mock
        var bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["com.test"],
            log: { logs.append($0) },
            isVerbose: true,
            useSameVersion: true,
            inPlace: true
        )

        try bump.bump(flag: .minor)

        #expect(logs == ["Test2", "1 -> 1.1.0.1"])
        #expect(logs.count == 2)
        #expect(xcodeProj.saveChangesCalled)
    }

    @Test func bumpOutputVersionUnsureVersionHasThreeElements() throws {
        let xcodeProj = XcodeProjWrapperMock(
            targets: [
                Target(
                    name: "Test1",
                    buildConfigurations: [
                        BuildConfiguration(
                            bundleIdentifier: "test",
                            buildNumber: "1",
                            version: "1.0.0.1.1"
                        )
                    ]
                )
            ]
        )
        var logs: [String] = []

        var bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["test"],
            log: { logs.append($0) },
            isVerbose: true,
            useSameVersion: false,
            inPlace: true
        )

        try bump.bump(flag: .build)

        #expect(logs == ["Test1 1 -> 1.0.0.2"])
        #expect(logs.count == 1)
        #expect(xcodeProj.saveChangesCalled)
    }

    @Test func bumpOutputVerboseWhenInPlaceIsTrue() throws {
        var logs: [String] = []
        let xcodeProj = XcodeProjWrapperMock.mock
        var bump = try Bump(
            xcodeProj: xcodeProj,
            bundleIdentifiers: ["com.test"],
            log: { logs.append($0) },
            isVerbose: true,
            useSameVersion: false,
            inPlace: false
        )

        try bump.bump(flag: .minor)

        #expect(logs == ["Test2 1 -> 1.1.0.1"])
        #expect(logs.count == 1)
        #expect(!xcodeProj.saveChangesCalled)
    }

    @Test func bumpOutputVersionWithTwoBuildConfigs() throws {
        let xcodeProj = XcodeProjWrapperMock(
            targets: [
                Target(
                    name: "Test1",
                    buildConfigurations: [
                        BuildConfiguration(
                            bundleIdentifier: "test",
                            buildNumber: "1",
                            version: "1.0.0.1"
                        ),
                        BuildConfiguration(
                            bundleIdentifier: "test",
                            buildNumber: "1",
                            version: "1.0.0.1"
                        )
                    ]
                )
            ]
        )
        var logs: [String] = []

        var bump = try Bump(
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

        #expect(logs == ["Test1 1 -> 1.0.0.2"])
        #expect(logs.count == 1)
        #expect(!xcodeProj.saveChangesCalled)
    }
}
