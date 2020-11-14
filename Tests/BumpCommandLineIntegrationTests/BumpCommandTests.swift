import ArgumentParser
import Foundation
import FileManagerWrapperMock
import XCTest
import XcodeProjWrapperMock

@testable import BumpCommandLine

final class BumpCommandTests: XCTestCase {
    var logs: [String] = []
    var command = BumpCommand()
    
    override func setUpWithError() throws {
        logs = []
        Current = .init(
            logger: { self.logs.append($0) }
        )
        command = BumpCommand()
    }
    
    func testBumpWithDirectory() throws {
        let resourcesPath = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Resources")
        
        command.path = resourcesPath.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = false
        command.inPlace = false
        
        try command.run()
        
        logs.sort()
        
        XCTAssertEqual(logs, ["1.5.0.2", "1.5.0.2", "2.5.0.2"])
    }
    
    func testBumpWithXcodeproj() throws {
        let resourcesPath = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Resources")
            .appendingPathComponent("SampleProject.xcodeproj")
        
        command.path = resourcesPath.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = false
        command.inPlace = false
        
        try command.run()
        
        logs.sort()
        
        XCTAssertEqual(logs, ["1.5.0.2", "1.5.0.2", "2.5.0.2"])
    }
}
