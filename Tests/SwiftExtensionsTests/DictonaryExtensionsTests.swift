import Foundation
import XCTest

@testable internal import SwiftExtensions

final class DictonaryExtensionsTests: XCTestCase {
    func testSubscriptGet() throws {
        enum Index: String {
            case zero
            case one
        }

        let numbers = [ "zero": 0, "one": 1 ]

        XCTAssertEqual(numbers[Index.zero], 0)
        XCTAssertEqual(numbers[Index.one], 1)
    }

    func testSubscriptSet() throws {
        enum Index: String {
            case zero
            case one
        }

        var numbers = [ "zero": 0, "one": 1 ]

        numbers[Index.zero] = 12
        numbers[Index.one] = 13

        XCTAssertEqual(numbers, [ "zero": 12, "one": 13 ])
    }
}
