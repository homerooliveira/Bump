import Foundation
import SnapshotTesting
import XCTest

@testable import BumpCommandLine

final class BumpCommandTests: XCTestCase {
    
    func testBump_Help() throws {
        let helpText = BumpCommand.helpMessage().replacingOccurrences(of: #"(?s)\(default:.*\)"#, with: "(default:)", options: .regularExpression)
        
        assertSnapshot(matching: helpText, as: .lines)
    }
}
