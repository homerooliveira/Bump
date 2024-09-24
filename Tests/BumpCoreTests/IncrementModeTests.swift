import Foundation
import Testing

@testable import BumpCore

struct IncrementModeTests {
    @Test func rawValue() throws {
        let expectedValues = ["major", "minor", "patch", "build", "1.0.0"]

        let modes: [IncrementMode] = [.major, .minor, .patch, .build, .versionString("1.0.0")]

        #expect(modes.map(\.rawValue) == expectedValues)
    }

    @Test func initFromRawValue() throws {
        let expectedModes: [IncrementMode] = [.major, .minor, .patch, .build, .versionString("1.0.0")]

        let values = ["major", "minor", "patch", "build", "1.0.0"]

        #expect(
            values.compactMap(IncrementMode.init(rawValue:)) == expectedModes
        )
    }
}
