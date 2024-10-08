import Foundation
import XCTest

@testable internal import FileManagerWrapper

final class URLTests: XCTestCase {
    func testIsXcodeProjTrue() throws {
        let url = try XCTUnwrap(URL(string: "test.xcodeproj"))
        XCTAssertTrue(url.isXcodeProj)
    }

    func testIsXcodeProjFalse() throws {
        let url = try XCTUnwrap(URL(string: "test.txt"))
        XCTAssertFalse(url.isXcodeProj)
    }
}
