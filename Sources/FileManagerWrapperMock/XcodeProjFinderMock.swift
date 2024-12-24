public import FileManagerWrapper
import Foundation

public final class XcodeProjFinderMock: XcodeProjFinderProtocol {
    public init() {}

    public private(set) var findXcodeProjPathCalled = false
    public private(set) var findXcodeProjPathPassed: String?
    public var findXcodeProjPathBeReturned: Result<String, any Error> = .success("")

    public func findXcodeProj(path: String?) throws -> String {
        findXcodeProjPathCalled = true
        findXcodeProjPathPassed = path
        return try findXcodeProjPathBeReturned.get()
    }

    public func reset() {
        findXcodeProjPathCalled = false
        findXcodeProjPathBeReturned = .success("")
    }
}
