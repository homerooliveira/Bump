import Foundation

package enum IncrementMode: RawRepresentable, Equatable, Sendable {
    case major
    case minor
    case patch
    case build
    case versionString(String)

    package var rawValue: String {
        switch self {
        case .major:
            return "major"
        case .minor:
            return "minor"
        case .patch:
            return "patch"
        case .build:
            return "build"
        case .versionString(let version):
            return version
        }
    }

    package init?(rawValue: String) {
        switch rawValue {
        case "major":
            self = .major
        case "minor":
            self = .minor
        case "patch":
            self = .patch
        case "build":
            self = .build

        default:
            self = .versionString(rawValue)
        }
    }
}
