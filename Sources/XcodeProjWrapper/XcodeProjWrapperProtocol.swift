import Foundation

public protocol XcodeProjWrapperProtocol {
    var targets: [Target] { get }

    mutating func saveChanges() throws
}
