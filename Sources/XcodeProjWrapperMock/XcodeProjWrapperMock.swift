package import XcodeProjWrapper

package final class XcodeProjWrapperMock: XcodeProjWrapperProtocol {
    package var targets: [Target]
    package private(set) var saveChangesCalled = false

    package init(targets: [Target] = []) {
        self.targets = targets
    }

    package func saveChanges() {
        saveChangesCalled = true
    }

    package func reset() {
        targets = []
        saveChangesCalled = false
    }
}
