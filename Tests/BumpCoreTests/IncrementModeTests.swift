import Foundation
import Testing

@testable import BumpCore

struct IncrementModeTests {
    @Test(
        arguments: [
            (value: IncrementMode.major, expected: "major"),
            (value: IncrementMode.minor, expected: "minor"),
            (value: IncrementMode.patch, expected: "patch"),
            (value: IncrementMode.build, expected: "build"),
            (value: IncrementMode.versionString("1.0.0"), expected: "1.0.0"),
        ]
    )
    func rawValue(value: IncrementMode, expected: String) throws {
        try #require(value.rawValue == expected)
    }

    @Test(
        arguments: [
            (value: "major", expected: IncrementMode.major),
            (value: "minor", expected: IncrementMode.minor),
            (value: "patch", expected: IncrementMode.patch),
            (value: "build", expected: IncrementMode.build),
            (value: "1.0.0", expected: IncrementMode.versionString("1.0.0")),
        ]
    )
    func initFromRawValue(value: String, expected: IncrementMode) throws {
        try #require(IncrementMode(rawValue: value) == expected)
    }
}
