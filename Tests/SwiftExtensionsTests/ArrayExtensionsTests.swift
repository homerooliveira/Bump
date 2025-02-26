import Foundation
import Testing

@testable import SwiftExtensions

struct ArrayExtensionsTests {
    enum Index: Int {
        case zero
        case one
    }

    @Test(
        arguments: [
            (value: Index.zero, expected: 0),
            (value: Index.one, expected: 1)
        ]
    )
    func subscriptGet(value: Index, expected: Int) throws {
        let numbers = [0, 1]
        try #require(numbers[value] == expected)
    }

    @Test(
        arguments: [
            (value: Index.zero, expected: 12),
            (value: Index.one, expected: 13)
        ]
    )
    func subscriptSet(value: Index, expected: Int) throws {
        var numbers = [0, 1]

        numbers[value] = expected

        #expect(numbers[value] == expected)
    }
}
