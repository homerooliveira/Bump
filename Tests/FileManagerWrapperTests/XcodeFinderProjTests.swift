import FileManagerWrapperMock
import XCTest

@testable import FileManagerWrapper

final class XcodeProjFinderTests: XCTestCase {
    private let fileManagerWrapperMock = FileManagerWrapperMock()
    private lazy var finder = XcodeProjFinder(fileManagerWrapper: fileManagerWrapperMock)

    override func setUpWithError() throws {
        fileManagerWrapperMock.reset()
    }

    func testFindXcodeProjPath() throws {
        let path = "/test"
        fileManagerWrapperMock.fileExistsBeReturned = true
        fileManagerWrapperMock.contentsOfDirectoryBeReturned = [URL(string: "/test/test.xcodeproj")!]

        let result = try finder.findXcodeProj(path: path)

        XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
        XCTAssertEqual(fileManagerWrapperMock.atPathPassed, path)
        XCTAssertTrue(fileManagerWrapperMock.contentsOfDirectoryCalled)
        XCTAssertEqual(fileManagerWrapperMock.atURLPassed, URL(string: path))
        XCTAssertEqual(result, "/test/test.xcodeproj")
    }

    func testFindXcodeProjPathWhenPathIsNil() throws {
        fileManagerWrapperMock.fileExistsBeReturned = true
        fileManagerWrapperMock.contentsOfDirectoryBeReturned = [URL(string: "/test/test.xcodeproj")!]
        fileManagerWrapperMock.currentDirectoryPath = "/test"

        let result = try finder.findXcodeProj(path: nil)

        XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
        XCTAssertEqual(fileManagerWrapperMock.atPathPassed, fileManagerWrapperMock.currentDirectoryPath)
        XCTAssertTrue(fileManagerWrapperMock.contentsOfDirectoryCalled)
        XCTAssertEqual(fileManagerWrapperMock.atURLPassed, URL(string: fileManagerWrapperMock.currentDirectoryPath))
        XCTAssertEqual(result, "/test/test.xcodeproj")
    }

    func testFindXcodeProjPathWhenFileExistsIsFalse() {
        fileManagerWrapperMock.fileExistsBeReturned = false

        XCTAssertThrowsError(try finder.findXcodeProj(path: "/test")) { error in
            guard let findError = error as? XcodeProjFinder.FindError else {
                XCTFail("Find error cannot be nil.")
                return
            }
            XCTAssertEqual(findError.description, "Needs exist a path of .xcodeproj file or directory.")
        }
        XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
        XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "/test")
    }
    
    func testFindXcodeProjPathWhenPathIsInvalid() {
        fileManagerWrapperMock.fileExistsBeReturned = true
        fileManagerWrapperMock.contentsOfDirectoryBeReturned = [URL(string: "/test/test.xcodeproj")!]

        XCTAssertThrowsError(try finder.findXcodeProj(path: "")) { error in
            guard let findError = error as? XcodeProjFinder.FindError else {
                XCTFail("Find error cannot be nil.")
                return
            }
            XCTAssertEqual(findError.description, "Wrong directory or path.")
        }
        XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
        XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "")
    }

    func testFindXcodeProjPathWhenPathIsNotXcodeProj() {
        fileManagerWrapperMock.fileExistsBeReturned = true
        fileManagerWrapperMock.contentsOfDirectoryBeReturned = [URL(string: "/test")!]

        XCTAssertThrowsError(try finder.findXcodeProj(path: "/test.txt")) { error in
            guard let findError = error as? XcodeProjFinder.FindError else {
                XCTFail("Find error cannot be nil.")
                return
            }
            XCTAssertEqual(findError.description, "The path must be .xcodeproj file or directory.")
        }
        XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
        XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "/test.txt")
    }

    func testFindXcodeProjPathWhenDirectoryIsEmpty() {
        fileManagerWrapperMock.fileExistsBeReturned = true
        fileManagerWrapperMock.contentsOfDirectoryBeReturned = []

        XCTAssertThrowsError(try finder.findXcodeProj(path: "/test")) { error in
            guard let findError = error as? XcodeProjFinder.FindError else {
                XCTFail("Find error cannot be nil.")
                return
            }
            XCTAssertEqual(findError.description, "Needs exist a .xcodeproj file in this directory.")
        }
        XCTAssertTrue(fileManagerWrapperMock.fileExistsCalled)
        XCTAssertEqual(fileManagerWrapperMock.atPathPassed, "/test")
        XCTAssertTrue(fileManagerWrapperMock.contentsOfDirectoryCalled)
        XCTAssertEqual(fileManagerWrapperMock.atURLPassed, URL(string: "/test"))
    }
}
