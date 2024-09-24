import Foundation
import Testing

@testable import FileManagerWrapper

struct URLTests {
    @Test func isXcodeProjTrue() throws {
        let url = try #require(URL(string: "test.xcodeproj"))
        #expect(url.isXcodeProj)
    }

    @Test func isXcodeProjFalse() throws {
        let url = try #require(URL(string: "test.txt"))
        #expect(!url.isXcodeProj)
    }
}
