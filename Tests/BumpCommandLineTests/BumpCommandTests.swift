import ArgumentParser
import Environment
import FileManagerWrapperMock
import XcodeProjWrapperMock
import Foundation
import Testing
import XcodeProjWrapperMock

@testable import BumpCommandLine

final class BumpCommandTests {
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

    deinit {
        xcodeProjFinderMock.reset()
        xcodeProjWrapperMock.reset()
    }

    @Test func testBumpValidationErrorWhenBundleIdentifiersIsEmpty() throws {
        command.bundleIdentifiers = []
        command.mode = .build

        #expect {
            try self.command.validate()
        } throws: { error in
            guard let error = error as? ValidationError else {
                throw error
            }
            return error.message == "Bundle Identifiers cannot be empty."
        }
    }

    @Test func testBumpValidationErrorWhenBuildNumberIsLessThanThreeNumbers() throws {
        command.bundleIdentifiers = ["test"]
        command.mode = .versionString("1.0.")

        #expect {
            try self.command.validate()
        } throws: { error in
            guard let error = error as? ValidationError else {
                throw error
            }
            return error.message == "Invalid format, the version must only have numbers and have two dots or three dots. Example of versions: `1.0.0` or `1.0.0.1`."
        }
    }

    @Test func testBumpValidationErrorWhenBuildNumberIsGreaterThanThreeDots() throws {
        command.bundleIdentifiers = ["test"]
        command.mode = .versionString("1.0.0.0.1")

        #expect {
            try self.command.validate()
        } throws: { error in
            guard let error = error as? ValidationError else {
                throw error
            }
            return error.message == "Invalid format, the version must only have numbers and have two dots or three dots. Example of versions: `1.0.0` or `1.0.0.1`."
        }
    }

    @Test func testBumpRunErrorWhenFileNotExist() throws {
        xcodeProjFinderMock.findXcodeProjPathBeReturned = .failure(CocoaError(.fileNoSuchFile))
        command.path = "test"
        command.bundleIdentifiers = ["test"]
        command.mode = .build

        #expect(
            throws: CocoaError(.fileNoSuchFile)
        ) {
            try self.command.run()
        }
        #expect(xcodeProjFinderMock.findXcodeProjPathPassed == "test")
        #expect(xcodeProjFinderMock.findXcodeProjPathCalled)
    }
}
