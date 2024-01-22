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

    func testSubscriptGetWithRange() throws {
        enum Index: Int, Comparable {
            case zero
            case one

            static func < (lhs: Index, rhs: Index) -> Bool {
                lhs.rawValue < rhs.rawValue
            }
        }

        let numbers = [0, 1, 2, 3, 4, 5]

        XCTAssertEqual(numbers[Index.zero...Index.one], [0, 1])
        XCTAssertEqual(numbers[Index.zero...], [0, 1, 2, 3, 4, 5])
        XCTAssertEqual(numbers[...Index.one], [0, 1])
        XCTAssertEqual(numbers[..<Index.one], [0])
    }
}
