import Foundation

public protocol XcodeProjWrapperProtocol {
    var targets: [any Target] { get }

    mutating func saveChanges() throws
}
