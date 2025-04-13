import FileManagerWrapper
import Foundation

package final class XcodeProjFinderMock: XcodeProjFinderProtocol {
    package init() {}

    package private(set) var findXcodeProjPathCalled = false
    package private(set) var findXcodeProjPathPassed: String?
    package var findXcodeProjPathBeReturned: Result<String, any Error> = .success("")

    package func findXcodeProj(path: String?) throws -> String {
        findXcodeProjPathCalled = true
        findXcodeProjPathPassed = path
        return try findXcodeProjPathBeReturned.get()
    }
}
