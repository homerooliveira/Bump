import FileManagerWrapper
import FileManagerWrapperMock
import XcodeProjWrapper
import XcodeProjWrapperMock
import XCTest

@testable import Environment

final class EnvironmentTests: XCTestCase {

    func testEnvironmentInitialization() throws {
        let mockXcodeProjFinder = XcodeProjFinderMock()
        let mockXcodeProjWrapper: (String) throws -> any XcodeProjWrapperProtocol = { _ in XcodeProjWrapperMock() }
        let mockLogger: (String) -> Void = { _ in }

        let environment = Environment(
            xcodeProjFinder: mockXcodeProjFinder,
            xcodeProjWrapper: mockXcodeProjWrapper,
            logger: mockLogger
        )

        XCTAssertTrue(environment.xcodeProjFinder is XcodeProjFinderMock)
        XCTAssertNotNil(try environment.xcodeProjWrapper("test") as? XcodeProjWrapperMock)
    }

    func testEnvironmentLiveInitialization() throws {
        let environment = Environment.live

        XCTAssertTrue(environment.xcodeProjFinder is XcodeProjFinder)
        XCTAssertThrowsError(try environment.xcodeProjWrapper("test"), "XcodeProjWrapper should throw an error because the path is invalid")
    }

    func testEnvironmentDecodable() throws {
        let json = "{}"
        let data = try XCTUnwrap(json.data(using: .utf8))
        let decoder = JSONDecoder()

        let environment = try decoder.decode(Environment.self, from: data)

        XCTAssertTrue(environment.xcodeProjFinder is XcodeProjFinder)
        XCTAssertThrowsError(try environment.xcodeProjWrapper("test"), "XcodeProjWrapper should throw an error because the path is invalid")
    }
}
