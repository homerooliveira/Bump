//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import XcodeProjWrapper

public final class XcodeProjWrapperMock: XcodeProjWrapperProtocol {
    public var targets: [any Target]
    public private(set) var saveChangesCalled = false

    public init(targets: [any Target] = []) {
        self.targets = targets
    }

    public func saveChanges() {
        saveChangesCalled = true
    }

    public func reset() {
        targets = []
        saveChangesCalled = false
    }
}
