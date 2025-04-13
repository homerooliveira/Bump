import ArgumentParser
import BumpCore
import FileManagerWrapperMock
import Foundation
import Testing
import XcodeProjWrapperMock

@testable import BumpCommandLine

struct BumpCommandTests {
    private let xcodeProjFinderMock: XcodeProjFinderMock
    private let xcodeProjWrapperMock: XcodeProjWrapperMock
    private var command: BumpCommand

    init() {
        let xcodeProjFinderMock = XcodeProjFinderMock()
        let xcodeProjWrapperMock = XcodeProjWrapperMock()
        self.xcodeProjFinderMock = xcodeProjFinderMock
        self.xcodeProjWrapperMock = xcodeProjWrapperMock
        let environment = Environment(
            xcodeProjFinder: xcodeProjFinderMock,
            xcodeProjWrapper: { _ in xcodeProjWrapperMock },
            logger: { _ in }
        )
        command = BumpCommand(environment: environment)
    }

    @Test mutating func testBumpValidationErrorWhenBundleIdentifiersIsEmpty() throws {
        command.bundleIdentifiers = []
        command.mode = .build

        let error = try #require(throws: ValidationError.self) {
            try self.command.validate()
        }

        #expect(error.message == "Bundle Identifiers cannot be empty.")
    }

    @Test mutating func testBumpValidationErrorWhenBuildNumberIsLessThanThreeNumbers() throws {
        command.bundleIdentifiers = ["test"]
        command.mode = .versionString("1.0.")

        let error = try #require(throws: ValidationError.self) {
            try self.command.validate()
        }

        #expect(
            error.message
                == "Invalid format, the version must only have numbers and have two dots or three dots. Example of versions: `1.0.0` or `1.0.0.1`."
        )
    }

    @Test mutating func testBumpValidationErrorWhenBuildNumberIsGreaterThanThreeDots() throws {
        command.bundleIdentifiers = ["test"]
        command.mode = .versionString("1.0.0.0.1")

        let error = try #require(throws: ValidationError.self) {
            try self.command.validate()
        }

        #expect(
            error.message
                == "Invalid format, the version must only have numbers and have two dots or three dots. Example of versions: `1.0.0` or `1.0.0.1`."
        )
    }

    @Test mutating func testBumpRunErrorWhenFileNotExist() throws {
        xcodeProjFinderMock.findXcodeProjPathBeReturned = .failure(CocoaError(.fileNoSuchFile))
        command.path = "test"
        command.bundleIdentifiers = ["test"]
        command.mode = .build

        try #require(throws: CocoaError(.fileNoSuchFile)) {
            try self.command.run()
        }
        #expect(xcodeProjFinderMock.findXcodeProjPathPassed == "test")
        #expect(xcodeProjFinderMock.findXcodeProjPathCalled)
    }
}
