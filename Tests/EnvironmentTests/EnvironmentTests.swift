import FileManagerWrapper
import FileManagerWrapperMock
import Foundation
import Testing
import XcodeProjWrapper
import XcodeProjWrapperMock

@testable import Environment

struct EnvironmentTests {
    @Test func testEnvironmentInitialization() throws {
        let mockXcodeProjFinder = XcodeProjFinderMock()
        let mockXcodeProjWrapper: (String) throws -> any XcodeProjWrapperProtocol = { _ in XcodeProjWrapperMock() }
        let mockLogger: (String) -> Void = { _ in }

        let environment = Environment(
            xcodeProjFinder: mockXcodeProjFinder,
            xcodeProjWrapper: mockXcodeProjWrapper,
            logger: mockLogger
        )

        #expect(environment.xcodeProjFinder is XcodeProjFinderMock)
        #expect(try environment.xcodeProjWrapper("test") as? XcodeProjWrapperMock != nil)
    }

    @Test func testEnvironmentLiveInitialization() throws {
        let environment = Environment.live

        #expect(environment.xcodeProjFinder is XcodeProjFinder)
        #expect(throws: (any Error).self, "XcodeProjWrapper should throw an error because the path is invalid") {
            try environment.xcodeProjWrapper("test")
        }
    }

    @Test func testEnvironmentDecodable() throws {
        let json = "{}"
        let data = try #require(json.data(using: .utf8))
        let decoder = JSONDecoder()

        let environment = try decoder.decode(Environment.self, from: data)

        #expect(environment.xcodeProjFinder is XcodeProjFinder)
        #expect(throws: (any Error).self, "XcodeProjWrapper should throw an error because the path is invalid") {
            try environment.xcodeProjWrapper("test")
        }
    }
}
