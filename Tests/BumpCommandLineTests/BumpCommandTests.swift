import ArgumentParser
import Environment
import FileManagerWrapperMock
import Foundation
import XcodeProjWrapperMock
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

    // func testBumpRunErrorWhenFileNotExist() throws {
    //     command.path = "test"
    //     command.bundleIdentifiers = ["test"]
    //     command.mode = .build

    //     XCTAssertThrowsError(try command.run()) { error in
    //         guard let validationError = error as? ValidationError else {
    //             XCTFail("Validation error cannot be nil.")
    //             return
    //         }
    //         XCTAssertEqual(validationError.description, "Needs exist a path of .xcodeproj file or directory.")
    //     }
    //     XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "test")
    //     XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
    // }

    // func testBumpValitionErrorWhenFileIsNotXcodeProj() throws {
    //     fileManagerWrapperMock.fileExistsBeReturned = true

    //     command.path = "test.txt"
    //     command.bundleIdentifiers = ["test"]
    //     command.mode = .build

    //     XCTAssertThrowsError(try command.run()) { error in
    //         guard let validationError = error as? ValidationError else {
    //             XCTFail("Validation error cannot be nil.")
    //             return
    //         }
    //         XCTAssertEqual(validationError.description, "The path must be .xcodeproj file or directory.")
    //     }
    //     XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "test.txt")
    //     XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
    // }

    // func testBumpValitionWhenFileIsXcodeProj() throws {
    //     fileManagerWrapperMock.fileExistsBeReturned = true

    //     command.path = "test.xcodeproj"
    //     command.bundleIdentifiers = ["test"]
    //     command.mode = .build
    //     command.useSameVersion = false
    //     command.verbose = false
    //     command.inPlace = false

    //     XCTAssertNoThrow(try command.run())

    //     XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "test.xcodeproj")
    //     XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
    // }

    // func testBumpValitionErrorWhenDirectoryNotHaveXcodeProj() throws {
    //     fileManagerWrapperMock.fileExistsBeReturned = true

    //     command.path = "test/"
    //     command.bundleIdentifiers = ["test"]
    //     command.mode = .build

    //     XCTAssertThrowsError(try command.run()) { error in
    //         guard let validationError = error as? ValidationError else {
    //             XCTFail("Validation error cannot be nil.")
    //             return
    //         }
    //         XCTAssertEqual(validationError.description, "Needs exist a .xcodeproj file in this directory.")
    //     }
    //     XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "test/")
    //     XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)

    //     XCTAssertTrue(fileManagerWrapperMock.contentsOfDirectoryCalled)
    //     XCTAssertEqual(fileManagerWrapperMock.atURLPassed, URL(string: "test/"))
    // }

    // func testBumpRunWhenDirectoryHaveXcodeProj() throws {
    //     fileManagerWrapperMock.currentDirectoryPath = "test/"
    //     fileManagerWrapperMock.fileExistsBeReturned = true
    //     fileManagerWrapperMock.contentsOfDirectoryBeReturned = [ URL(string: "test.xcodeproj")! ]

    //     command.path = nil
    //     command.bundleIdentifiers = ["test"]
    //     command.mode = .build
    //     command.useSameVersion = false
    //     command.verbose = false
    //     command.inPlace = false

    //     try command.run()

    //     XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
    //     XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "test/")

    //     XCTAssertTrue(fileManagerWrapperMock.contentsOfDirectoryCalled)
    //     XCTAssertEqual(fileManagerWrapperMock.atURLPassed, URL(string: "test/"))
    // }

    // func testBumpValitionWhenDirectoryHaveXcodeProj() throws {
    //     fileManagerWrapperMock.fileExistsBeReturned = true
    //     fileManagerWrapperMock.contentsOfDirectoryBeReturned = [ URL(string: "test.xcodeproj")! ]

    //     command.path = "test/"
    //     command.bundleIdentifiers = ["test"]
    //     command.mode = .build
    //     command.useSameVersion = false
    //     command.verbose = false
    //     command.inPlace = false

    //     try command.run()

    //     XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
    //     XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "test/")

    //     XCTAssertTrue(fileManagerWrapperMock.contentsOfDirectoryCalled)
    //     XCTAssertEqual(fileManagerWrapperMock.atURLPassed, URL(string: "test/"))
    // }
}
