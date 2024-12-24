import Foundation
import Testing

@testable import SwiftExtensions

struct DictonaryExtensionsTests {
    @Test func subscriptGet() {
        enum Index: String {
            case zero
            case one
        }

        let numbers = [ "zero": 0, "one": 1 ]

        #expect(numbers[Index.zero] == 0)
        #expect(numbers[Index.one] == 1)
    }

    @Test func subscriptSet() {
        enum Index: String {
            case zero
            case one
        }

        var numbers = [ "zero": 0, "one": 1 ]

        numbers[Index.zero] = 12
        numbers[Index.one] = 13

        #expect(numbers == [ "zero": 12, "one": 13 ])
    }
}
