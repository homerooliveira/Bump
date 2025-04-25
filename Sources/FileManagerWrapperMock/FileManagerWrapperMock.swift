import FileManagerWrapper
package import Foundation

package final class FileManagerWrapperMock: FileManagerProtocol {
    package var currentDirectoryPath: String = ""

    package init() {}

    package var atPathPassed: String?
    package private(set) var fileExistsCalled = false
    package var fileExistsBeReturned = false

    package func fileExists(atPath: String) -> Bool {
        atPathPassed = atPath
        fileExistsCalled = true
        return fileExistsBeReturned
    }

    package var atURLPassed: URL?
    package private(set) var contentsOfDirectoryCalled = false
    package var contentsOfDirectoryBeReturned: [URL] = []

    package func contentsOfDirectory(at url: URL) throws -> [URL] {
        atURLPassed = url
        contentsOfDirectoryCalled = true
        return contentsOfDirectoryBeReturned
    }
}
