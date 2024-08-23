internal import ArgumentParser
internal import Environment
import Foundation
import XCTest

@testable internal import BumpCommandLine

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

    func testBumpWithXcodeprojWhenPathIsNil() throws {
        command.path = nil
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = false
        command.inPlace = false

        // This will throw an error because the current directory does not have an xcodeproj file
        XCTAssertThrowsError(try command.run())
    }

    func testBumpWithInPlaceTrue() throws {
        let resourcesPath = try fixturesPath()
            .appending(component: "SampleProject.xcodeproj")

        let temporaryFile = try copyFileToTemporaryPath(url: resourcesPath)

        command.path = temporaryFile.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = false
        command.inPlace = true

        try command.run()

        logs.sort()

        XCTAssertEqual(logs, ["1.5.0.2", "1.5.0.2", "2.5.0.2"])

        // Remove the temporary file
        try FileManager.default.removeItem(at: temporaryFile)
    }

    private func copyFileToTemporaryPath(url: URL) throws -> URL {
        let fileManager = FileManager.default

        let tempDirectory = fileManager.temporaryDirectory
        let tempFileURL = tempDirectory.appendingPathComponent("SampleProject.xcodeproj")

        try fileManager.copyItem(at: url, to: tempFileURL)

        return tempFileURL
    }

    private func fixturesPath() throws -> URL {
        try XCTUnwrap(Bundle.module.resourceURL)
    }
}
