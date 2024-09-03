import Foundation

public protocol BuildConfiguration {
    var bundleIdentifier: String { get }
    var buildNumber: String? { get set }
    var version: String? { get set }
}
