internal import ArgumentParser
internal import Environment
internal import FileManagerWrapperMock
import Foundation
internal import XcodeProjWrapperMock
import XCTest

@testable import BumpCommandLine

final class BumpCommandTests: XCTestCase {
    private var xcodeProjFinderMock = XcodeProjFinderMock()
    private var xcodeProjWrapperMock = XcodeProjWrapperMock()
    private var logs: [String] = []
    private var command = BumpCommand()

    override func setUpWithError() throws {
        xcodeProjFinderMock.reset()
        xcodeProjWrapperMock.reset()
        logs = []
        let environment = Environment(
            xcodeProjFinder: xcodeProjFinderMock,
            xcodeProjWrapper: { _ in  self.xcodeProjWrapperMock },
            logger: { self.logs.append($0) }
        )
        command = BumpCommand(environment: environment)
    }

    func testBumpValitionErrorWhenBundleIdentifiersIsEmpty() throws {
        command.bundleIdentifiers = []
        command.mode = .build

        XCTAssertThrowsError(try command.validate()) { error in
            guard let validationError = error as? ValidationError else {
                XCTFail("Validation error cannot be nil.")
                return
            }
            XCTAssertEqual(validationError.description, "Bundle Identifiers cannot be empty.")
        }
    }

    func testBumpValitionErrorWhenBuildNumberIsLessThanThreeNumbers() throws {
        command.bundleIdentifiers = ["test"]
        command.mode = .versionString("1.0.")

        XCTAssertThrowsError(try command.validate()) { error in
            guard let validationError = error as? ValidationError else {
                XCTFail("Validation error cannot be nil.")
                return
            }
            let expectedError = "Invalid format, the version must only have numbers and have two dots or three dots. Example of versions: `1.0.0` or `1.0.0.1`."
            XCTAssertEqual(validationError.description, expectedError)
        }
    }

    func testBumpValitionErrorWhenBuildNumberIsGreaterThanThreeDots() throws {
        command.bundleIdentifiers = ["test"]
        command.mode = .versionString("1.0.0.0.1")

        XCTAssertThrowsError(try command.validate()) { error in
            guard let validationError = error as? ValidationError else {
                XCTFail("Validation error cannot be nil.")
                return
            }
            let expectedError = "Invalid format, the version must only have numbers and have two dots or three dots. Example of versions: `1.0.0` or `1.0.0.1`."
            XCTAssertEqual(validationError.description, expectedError)
        }
    }

    func testBumpRunErrorWhenFileNotExist() throws {
        xcodeProjFinderMock.findXcodeProjPathBeReturned = .failure(CocoaError(.fileNoSuchFile))
        command.path = "test"
        command.bundleIdentifiers = ["test"]
        command.mode = .build

        XCTAssertThrowsError(try command.run()) { error in
            guard let validationError = error as? CocoaError else {
                XCTFail("Validation error cannot be nil.")
                return
            }
            XCTAssertEqual(validationError, CocoaError(.fileNoSuchFile))
        }
        XCTAssertEqual(xcodeProjFinderMock.findXcodeProjPathPassed, "test")
        XCTAssertTrue(xcodeProjFinderMock.findXcodeProjPathCalled)
    }
}
