import Foundation
import Testing

@testable import FileManagerWrapper

struct URLTests {
    @Test(
        arguments: [
            (value: "test.xcodeproj", expected: true),
            (value: "test.txt", expected: false),
        ]
    )
    func isXcodeProj(value: String, expected: Bool) throws {
        let url = try #require(URL(string: value))
        try #require(url.isXcodeProj == expected)
    }
}
