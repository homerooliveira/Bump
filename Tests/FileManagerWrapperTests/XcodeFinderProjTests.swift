import FileManagerWrapperMock
import Foundation
import Testing

@testable import FileManagerWrapper

final class XcodeProjFinderTests {
    let fileManagerWrapper: FileManagerWrapperMock
    let sut: XcodeProjFinder

    init() {
        fileManagerWrapper = FileManagerWrapperMock()
        sut = XcodeProjFinder(fileManagerWrapper: fileManagerWrapper)
    }

    deinit {
        fileManagerWrapper.reset()
    }

    @Test func findXcodeProjPath() throws {
        let path = "/test"
        fileManagerWrapper.fileExistsBeReturned = true
        fileManagerWrapper.contentsOfDirectoryBeReturned = [URL(string: "/test/test.xcodeproj")!]

        let result = try sut.findXcodeProj(path: path)

        #expect(fileManagerWrapper.fileExistsCalled)
        #expect(fileManagerWrapper.atPathPassed == path)
        #expect(fileManagerWrapper.contentsOfDirectoryCalled)
        #expect(fileManagerWrapper.atURLPassed == URL(string: path))
        #expect(result == "/test/test.xcodeproj")
    }

    @Test func findXcodeProjPathWhenPathIsNil() throws {
        fileManagerWrapper.fileExistsBeReturned = true
        fileManagerWrapper.contentsOfDirectoryBeReturned = [URL(string: "/test/test.xcodeproj")!]
        fileManagerWrapper.currentDirectoryPath = "/test"

        let result = try sut.findXcodeProj(path: nil)

        #expect(fileManagerWrapper.fileExistsCalled)
        #expect(fileManagerWrapper.atPathPassed == fileManagerWrapper.currentDirectoryPath)
        #expect(fileManagerWrapper.contentsOfDirectoryCalled)
        #expect(fileManagerWrapper.atURLPassed == URL(string: fileManagerWrapper.currentDirectoryPath))
        #expect(result == "/test/test.xcodeproj")
    }

    @Test func findXcodeProjPathWhenFileExistsIsFalse() {
        fileManagerWrapper.fileExistsBeReturned = false

        #expect(
            throws: XcodeProjFinder.FindError("Needs exist a path of .xcodeproj file or directory.")
        ) {
            try sut.findXcodeProj(path: "/test")
        }
        #expect(fileManagerWrapper.fileExistsCalled)
        #expect(fileManagerWrapper.atPathPassed == "/test")
    }

    @Test func findXcodeProjPathWhenPathIsInvalid() {
        fileManagerWrapper.fileExistsBeReturned = true
        fileManagerWrapper.contentsOfDirectoryBeReturned = [URL(string: "/test/test.xcodeproj")!]

        #expect(
            throws: XcodeProjFinder.FindError("Wrong directory or path.")
        ) {
            try sut.findXcodeProj(path: "")
        }
        #expect(fileManagerWrapper.fileExistsCalled)
        #expect(fileManagerWrapper.atPathPassed == "")
    }

    @Test func findXcodeProjPathWhenPathIsNotXcodeProj() {
        fileManagerWrapper.fileExistsBeReturned = true
        fileManagerWrapper.contentsOfDirectoryBeReturned = [URL(string: "/test")!]

        #expect(
            throws: XcodeProjFinder.FindError("The path must be .xcodeproj file or directory.")
        ) {
            try sut.findXcodeProj(path: "/test.txt")
        }
        #expect(fileManagerWrapper.fileExistsCalled)
        #expect(fileManagerWrapper.atPathPassed == "/test.txt")
    }

    @Test func findXcodeProjPathWhenDirectoryIsEmpty() {
        fileManagerWrapper.fileExistsBeReturned = true
        fileManagerWrapper.contentsOfDirectoryBeReturned = []

        #expect(
            throws: XcodeProjFinder.FindError("Needs exist a .xcodeproj file in this directory.")
        ) {
            try sut.findXcodeProj(path: "/test")
        }
        #expect(fileManagerWrapper.fileExistsCalled)
        #expect(fileManagerWrapper.atPathPassed == "/test")
        #expect(fileManagerWrapper.contentsOfDirectoryCalled)
        #expect(fileManagerWrapper.atURLPassed == URL(string: "/test"))
    }
}
