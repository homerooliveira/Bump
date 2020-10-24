import Foundation
import XCTest

@testable import SwiftExtensions

final class ArrayExtensionsTests: XCTestCase {
    func testSubscriptGet() throws {
        enum Index: Int {
            case zero
            case one
        }
        
        let numbers = [0, 1]
        
        XCTAssertEqual(numbers[Index.zero], 0)
        XCTAssertEqual(numbers[Index.one], 1)
    }
    
    func testSubscriptSet() throws {
        enum Index: Int {
            case zero
            case one
        }
        
        var numbers = [0, 1]
        
        numbers[Index.zero] = 12
        numbers[Index.one] = 13
        
        XCTAssertEqual(numbers, [12, 13])
    }
}
