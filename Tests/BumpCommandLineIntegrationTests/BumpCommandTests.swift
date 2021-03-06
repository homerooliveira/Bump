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
        let resourcesPath = fixturesPath()
        
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
        let resourcesPath = fixturesPath()
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
    
    func testBumpWithDirectoryWhenVerboseIsTrue() throws {
        let resourcesPath = fixturesPath()
        
        command.path = resourcesPath.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = true
        command.inPlace = false
        
        try command.run()
        
        logs.sort()
        
        XCTAssertEqual(
            logs,
            [
                "Test1 1.5.0.1 -> 1.5.0.2",
                "Test2Intention 1.5.0.1 -> 1.5.0.2",
                "TestIntetion 2.5.0.1 -> 2.5.0.2"
            ]
        )
    }
    
    func testBumpWithXcodeprojWhenVerboseIsTrue() throws {
        let resourcesPath = fixturesPath()
            .appendingPathComponent("SampleProject.xcodeproj")
        
        command.path = resourcesPath.path
        command.bundleIdentifiers = ["com.test.Test1"]
        command.mode = .build
        command.useSameVersion = false
        command.verbose = true
        command.inPlace = false
        
        try command.run()
        
        logs.sort()
        
        XCTAssertEqual(
            logs,
            [
                "Test1 1.5.0.1 -> 1.5.0.2",
                "Test2Intention 1.5.0.1 -> 1.5.0.2",
                "TestIntetion 2.5.0.1 -> 2.5.0.2"
            ]
        )
        
        try command.run()
    }
}
