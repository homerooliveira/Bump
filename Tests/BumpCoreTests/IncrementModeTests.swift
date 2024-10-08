import Foundation
import XCTest

@testable internal import BumpCore

final class IncrementModeTests: XCTestCase {
    func testRawValue() throws {
        let expectedValues = ["major", "minor", "patch", "build", "1.0.0"]

        let modes: [IncrementMode] = [.major, .minor, .patch, .build, .versionString("1.0.0")]

        XCTAssertEqual(modes.map(\.rawValue), expectedValues)
    }

    func testInit() throws {
        let expectedModes: [IncrementMode] = [.major, .minor, .patch, .build, .versionString("1.0.0")]

        let values = ["major", "minor", "patch", "build", "1.0.0"]

        XCTAssertEqual(
            values.compactMap(IncrementMode.init(rawValue:)),
            expectedModes
        )
    }
}
