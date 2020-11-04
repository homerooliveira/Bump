import ArgumentParser
import Foundation
import FileManagerWrapperMock
import XCTest
import XcodeProjWrapperMock

@testable import BumpCommandLine

final class BumpCommandTests: XCTestCase {
    var fileManagerWrapperMock = FileManagerWrapperMock()
    var xcodeProjWrapperMock = XcodeProjWrapperMock()
    var logs: [String] = []
    var command = BumpCommand()
    
    override func setUpWithError() throws {
        fileManagerWrapperMock.reset()
        xcodeProjWrapperMock.reset()
        logs = []
        Current = .init(
            fileManagerWrapper: fileManagerWrapperMock,
            xcodeProjWrapper: { _ in  self.xcodeProjWrapperMock },
            logger: { self.logs.append($0) }
        )
        command = BumpCommand()
    }
    
    func testBumpHelp() throws {
        let expected = "OVERVIEW: Bump your projects.\n\nUSAGE: bump [<bundle-identifiers> ...] --mode <mode> [--path <path>] [--verbose] [--use-same-version]\n\nARGUMENTS:\n  <bundle-identifiers>    Bundle Identifiers to search aplications/frameworks. \n\nOPTIONS:\n  -m, --mode <mode>       Increment mode to bump version or build number.\n                          Either \'major\', \'minor\', \'patch\', or \'build\'. \n  -p, --path <path>       The path of .xcodeproj file or directory. Default\n                          value is the current directory. \n  -v, --verbose           Show all the targets \n  -u, --use-same-version  Get the version of the first target and set it to the\n                          rest of the targets. \n  -h, --help              Show help information.\n"
        
        let helpText = BumpCommand.helpMessage()
        
        XCTAssertEqual(helpText, expected)
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
            XCTAssertEqual(validationError.description, "Invalid format, the version must only have numbers and have two dots or three dots. Example of versions: `1.0.0` or `1.0.0.1`.")
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
            XCTAssertEqual(validationError.description, "Invalid format, the version must only have numbers and have two dots or three dots. Example of versions: `1.0.0` or `1.0.0.1`.")
        }
    }
    
    func testBumpValitionErrorWhenFileNotExist() throws {
        command.path = "test"
        command.bundleIdentifiers = ["test"]
        command.mode = .build
        
        XCTAssertThrowsError(try command.run()) { error in
            guard let validationError = error as? ValidationError else {
                XCTFail("Validation error cannot be nil.")
                return
            }
            XCTAssertEqual(validationError.description, "Needs exist a path of .xcodeproj file or directory.")
        }
        XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "test")
        XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
    }

    func testBumpValitionErrorWhenFileIsNotXcodeProj() throws {
        fileManagerWrapperMock.fileExistsBeReturned = true
        
        command.path = "test.txt"
        command.bundleIdentifiers = ["test"]
        command.mode = .build
        
        XCTAssertThrowsError(try command.run()) { error in
            guard let validationError = error as? ValidationError else {
                XCTFail("Validation error cannot be nil.")
                return
            }
            XCTAssertEqual(validationError.description, "The path must be .xcodeproj file or directory.")
        }
        XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "test.txt")
        XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
    }
    
    func testBumpValitionWhenFileIsXcodeProj() throws {
        fileManagerWrapperMock.fileExistsBeReturned = true
        
        command.path = "test.xcodeproj"
        command.bundleIdentifiers = ["test"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = false
        
        XCTAssertNoThrow(try command.run())
        
        XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "test.xcodeproj")
        XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
    }

    func testBumpValitionErrorWhenDirectoryNotHaveXcodeProj() throws {
        fileManagerWrapperMock.fileExistsBeReturned = true
        
        command.path = "test/"
        command.bundleIdentifiers = ["test"]
        command.mode = .build
        
        XCTAssertThrowsError(try command.run()) { error in
            guard let validationError = error as? ValidationError else {
                XCTFail("Validation error cannot be nil.")
                return
            }
            XCTAssertEqual(validationError.description, "Needs exist a .xcodeproj file in this directory.")
        }
        XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "test/")
        XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
        
        XCTAssertTrue(fileManagerWrapperMock.contentsOfDirectoryCalled)
        XCTAssertEqual(fileManagerWrapperMock.atURLPassed, URL(string: "test/"))
    }
    
    func testBumpValitionErrorWhenDirectoryHaveXcodeProj() throws {
        fileManagerWrapperMock.fileExistsBeReturned = true
        fileManagerWrapperMock.contentsOfDirectoryBeReturned = [ URL(string: "test.xcodeproj")! ]
        
        command.path = "test/"
        command.bundleIdentifiers = ["test"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = false
        
        try command.run()
        
        XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
        XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "test/")
        
        XCTAssertTrue(fileManagerWrapperMock.contentsOfDirectoryCalled)
        XCTAssertEqual(fileManagerWrapperMock.atURLPassed, URL(string: "test/"))
    }
}
