import Foundation
import Testing

@testable import SwiftExtensions

struct ArrayExtensionsTests {
    @Test func subscriptGet() {
        enum Index: Int {
            case zero
            case one
        }

        let numbers = [0, 1]

        #expect(numbers[Index.zero] == 0)
        #expect(numbers[Index.one] == 1)
    }

    @Test func subscriptSet() {
        enum Index: Int {
            case zero
            case one
        }

        var numbers = [0, 1]

        numbers[Index.zero] = 12
        numbers[Index.one] = 13

        #expect(numbers == [12, 13])
    }
}
