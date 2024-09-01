import Foundation

public protocol XcodeProjWrapperProtocol {
    var targets: [any Target] { get }

    func saveChanges() throws
}
