import ArgumentParser
import Foundation
import FileManagerWrapper
import LoggerWrapperMock
import XCTest
import XcodeProjWrapper

@testable import BumpCommandLine
@testable import Environment

final class BumpCommandTests: XCTestCase {
    private let logger = LoggerWrapperMock()
    private var command = BumpCommand()
    
    override func setUpWithError() throws {
        logger.reset()
        
        Current = .init(
            fileManagerWrapper: FileManagerWrapper(),
            xcodeProjWrapper: { try XcodeProjWrapper(path: $0) }, 
            logger: logger
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
        
        let logs = logger.messages.sorted()
        
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
        
        let logs = logger.messages.sorted()
        
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
        
        let logs = logger.messages.sorted()
        
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
        
        let logs = logger.messages.sorted()
        
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
