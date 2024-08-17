import ArgumentParser
import Environment
import Foundation
import XCTest

@testable import BumpCommandLine

final class BumpCommandTests: XCTestCase {
    private var logs: [String] = []
    private var command = BumpCommand()

    override func setUpWithError() throws {
        logs = []
        command = BumpCommand(environment: Environment(logger: { self.logs.append($0) }))
    }

    func testBumpWithDirectory() throws {
        let resourcesPath = try fixturesPath()

        command.path = resourcesPath.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = false
        command.inPlace = false

        try command.run()

        logs.sort()

        XCTAssertEqual(logs, ["1.5.0.2", "1.5.0.2", "2.5.0.2"])
    }

    func testBumpWithXcodeproj() throws {
        let resourcesPath = try fixturesPath()
            .appendingPathComponent("SampleProject.xcodeproj")

        command.path = resourcesPath.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = false
        command.inPlace = false

        try command.run()

        logs.sort()

        XCTAssertEqual(logs, ["1.5.0.2", "1.5.0.2", "2.5.0.2"])
    }

    func testBumpWithDirectoryWhenVerboseIsTrue() throws {
        let resourcesPath = try fixturesPath()

        command.path = resourcesPath.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = true
        command.inPlace = false

        try command.run()

        logs.sort()

        XCTAssertEqual(
            logs,
            [
                "Test1 1.5.0.1 -> 1.5.0.2",
                "Test2Intention 1.5.0.1 -> 1.5.0.2",
                "TestIntetion 2.5.0.1 -> 2.5.0.2"
            ]
        )
    }

    func testBumpWithXcodeprojWhenVerboseIsTrue() throws {
        let resourcesPath = try fixturesPath()
            .appendingPathComponent("SampleProject.xcodeproj")

        command.path = resourcesPath.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = true
        command.inPlace = false

        try command.run()

        logs.sort()

        XCTAssertEqual(
            logs,
            [
                "Test1 1.5.0.1 -> 1.5.0.2",
                "Test2Intention 1.5.0.1 -> 1.5.0.2",
                "TestIntetion 2.5.0.1 -> 2.5.0.2"
            ]
        )

        try command.run()
    }
}
