import Foundation
import XCTest

@testable import SwiftExtensions

final class URLTests: XCTestCase {
    func testIsXcodeProjTrue() throws {
        let url = try XCTUnwrap(URL(string: "test.xcodeproj"))
        XCTAssertTrue(url.isXcodeProj)
    }

    func testIsXcodeProjUpperCaseExtension() throws {
        let url = try XCTUnwrap(URL(string: "test.XCODEPROJ"))
        XCTAssertTrue(url.isXcodeProj)
    }

    func testIsXcodeProjFalse() throws {
        let url = try XCTUnwrap(URL(string: "test.txt"))
        XCTAssertFalse(url.isXcodeProj)
    }

    func testIsXcodeProjEmptyPathExtension() throws {
        let url = try XCTUnwrap(URL(string: "test."))
        XCTAssertFalse(url.isXcodeProj)
    }
    
    func testIsXcodeProjNoExtension() throws {
        let url = try XCTUnwrap(URL(string: "test"))
        XCTAssertFalse(url.isXcodeProj)
    }
}
