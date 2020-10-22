import Foundation
import XCTest

@testable import BumpCommandLine

final class BumpCommandTests: XCTestCase {
    
    func testBump_Help() throws {
        let expected = "OVERVIEW: Bump your projects.\n\nUSAGE: bump [<bundle-identifiers> ...] --mode <mode> [--path <path>] [--verbose] [--use-same-version]\n\nARGUMENTS:\n  <bundle-identifiers>    Bundle Identifiers to search aplications/frameworks. \n\nOPTIONS:\n  -m, --mode <mode>       Increment mode to bump version or build number.\n                          Either \'major\', \'minor\', \'patch\', or \'build\'. \n  -p, --path <path>       The path of .xcodeproj file or directory. Default\n                          value is the current directory. (default:)\n  -v, --verbose           Show all the targets \n  -u, --use-same-version  Get the version of the first target and set it to the\n                          rest of the targets. \n  -h, --help              Show help information.\n"
        
        let helpText = BumpCommand.helpMessage().replacingOccurrences(of: #"(?s)\(default:.*\)"#, with: "(default:)", options: .regularExpression)
        
        XCTAssertEqual(expected, helpText)
    }
}
