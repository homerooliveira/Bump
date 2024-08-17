import FileManagerWrapper
import Foundation

public final class XcodeProjFinderMock: XcodeProjFinderProtocol {
    public init() {}
    
    public private(set) var findXcodeProjPathCalled = false
    public private(set) var findXcodeProjPathPassed: String?
    public var findXcodeProjPathBeReturned = ""
    
    public func findXcodeProj(path: String?) throws -> String {
        findXcodeProjPathCalled = true
        findXcodeProjPathPassed = path
        return findXcodeProjPathBeReturned
    }
    
    public func reset() {
        findXcodeProjPathCalled = false
        findXcodeProjPathBeReturned = ""
    }
}