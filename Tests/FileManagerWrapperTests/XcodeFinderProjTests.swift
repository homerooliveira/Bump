import FileManagerWrapperMock
import XCTest

@testable import FileManagerWrapper

final class XcodeProjFinderTests: XCTestCase {
    private let fileManagerWrapperMock = FileManagerWrapperMock()
    private lazy var finder = XcodeProjFinder(fileManagerWrapper: fileManagerWrapperMock)

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
}