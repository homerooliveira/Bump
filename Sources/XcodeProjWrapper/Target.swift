import Foundation

public protocol Target {
    var name: String { get }
    var buildConfigurations: [any BuildConfiguration] { get }
}
