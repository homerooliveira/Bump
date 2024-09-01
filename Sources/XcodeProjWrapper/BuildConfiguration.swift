import Foundation

public protocol BuildConfiguration: AnyObject {
    var bundleIdentifier: String { get }
    var buildNumber: String? { get set }
    var version: String? { get set }
}
