import ArgumentParser
import Environment
import FileManagerWrapper
import XcodeProjWrapper
import Foundation
import Testing
import XcodeProjWrapper

@testable import BumpCommandLine

final class Box<T>: Equatable where T: Equatable {
    var value: T

    init(_ value: T) {
        self.value = value
    }

    static func == (lhs: Box<T>, rhs: Box<T>) -> Bool {
        lhs.value == rhs.value
    }
}

struct BumpCommandIntegrationTests {

    @Test func bumpWithDirectory() throws {
        var (command, logs) = makeCommand()

        let resourcesPath = try fixturesPath()

        command.path = resourcesPath.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = false
        command.inPlace = false

        try command.run()

        logs.value.sort()

        #expect(logs == Box(["1.5.0.2", "1.5.0.2", "2.5.0.2"]))
    }

    @Test func bumpWithXcodeproj() throws {
        var (command, logs) = makeCommand()

        let resourcesPath = try fixturesPath()
            .appendingPathComponent("SampleProject.xcodeproj")

        command.path = resourcesPath.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = false
        command.inPlace = false

        try command.run()

        logs.value.sort()

        #expect(logs == Box(["1.5.0.2", "1.5.0.2", "2.5.0.2"]))
    }

    @Test func bumpWithDirectoryWhenVerboseIsTrue() throws {
        var (command, logs) = makeCommand()

        let resourcesPath = try fixturesPath()

        command.path = resourcesPath.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = true
        command.inPlace = false

        try command.run()

        logs.value.sort()

        #expect(
            logs == Box([
                "Test1 1.5.0.1 -> 1.5.0.2",
                "Test2Intention 1.5.0.1 -> 1.5.0.2",
                "TestIntetion 2.5.0.1 -> 2.5.0.2"
            ])
        )
    }

    @Test func bumpWithXcodeprojWhenVerboseIsTrue() throws {
        var (command, logs) = makeCommand()

        let resourcesPath = try fixturesPath()
            .appendingPathComponent("SampleProject.xcodeproj")

        command.path = resourcesPath.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = true
        command.inPlace = false

        try command.run()

        logs.value.sort()

        #expect(
            logs == Box([
                "Test1 1.5.0.1 -> 1.5.0.2",
                "Test2Intention 1.5.0.1 -> 1.5.0.2",
                "TestIntetion 2.5.0.1 -> 2.5.0.2"
            ])
        )
    }

    @Test func bumpWithXcodeprojWhenPathIsNil() {
        var (command, _) = makeCommand()

        command.path = nil
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = false
        command.inPlace = false

        #expect(throws: (any Error).self) {
            try command.run()
        }
    }

    @Test func bumpWithInPlaceTrue() throws {
        var (command, logs) = makeCommand()

        let resourcesPath = try fixturesPath()
            .appendingPathComponent("SampleProject.xcodeproj")

        let temporaryFile = try copyFileToTemporaryPath(fileURL: resourcesPath)

        command.path = temporaryFile.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = false
        command.inPlace = true

        try command.run()

        logs.value.sort()

        #expect(logs == Box(["1.5.0.2", "1.5.0.2", "2.5.0.2"]))

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

<<<<<<< HEAD:Tests/BumpCommandLineIntegrationTests/BumpCommandTests.swift
    private func makeEnvironment() -> Environment {
        Environment(
            xcodeProjFinder: XcodeProjFinder(fileManagerWrapper: FileManager.default),
            xcodeProjWrapper: { try XcodeProjWrapper(path: $0) },
            logger: { self.logs.append($0) }
=======
    private func makeCommand() -> (BumpCommand, Box<[String]>) {
        let logs: Box<[String]> = Box([])

        return (
            BumpCommand(
                environment: Environment(
                    xcodeProjFinder: XcodeProjFinder(),
                    xcodeProjWrapper: { try XcodeProjWrapper(path: $0) },
                    logger: { logs.value.append($0) }
                )
            ),
            logs
>>>>>>> b00c0d5 (Update code):Tests/BumpCommandLineIntegrationTests/BumpCommandIntegrationTests.swift
        )
    }
}
