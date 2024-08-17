import Environment
import Foundation
import XCTest

final class EnvironmentTests: XCTestCase {

    func test_decode_shouldReturnLiveEnvironment() throws {
        let data = Data("{}".utf8)
        let decoder = JSONDecoder()
        let environment = try decoder.decode(Environment.self, from: data)

        XCTAssertEqual(environment, Environment.live)
    }
}