import ArgumentParser
import Environment
import FileManagerWrapper
import XcodeProjWrapper
import Foundation
import XCTest

@testable import BumpCommandLine

final class BumpCommandIntegrationTests: XCTestCase {
    private var logs: [String] = []
    private var command = BumpCommand()

    override func setUpWithError() throws {
        logs = []
        command = BumpCommand(environment: makeEnvironment())
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

        let temporaryFile = try copyFileToTemporaryPath(fileURL: resourcesPath)

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

    private func copyFileToTemporaryPath(fileURL: URL) throws -> URL {
        let fileManager = FileManager.default
        let tempDirectory = fileManager.temporaryDirectory
        let tempFileURL = tempDirectory.appendingPathComponent("SampleProject.xcodeproj")

        try fileManager.copyItem(at: fileURL, to: tempFileURL)

        return tempFileURL
    }

    private func fixturesPath() throws -> URL {
        try XCTUnwrap(Bundle.module.resourceURL)
    }

    private func makeEnvironment() -> Environment {
        Environment(
            xcodeProjFinder: XcodeProjFinder(),
            xcodeProjWrapper: { try XcodeProjWrapper(path: $0) },
            logger: { self.logs.append($0) }
        )
    }
}
