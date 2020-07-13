//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import XcodeProjWrapper

final class XcodeProjWrapperMock: XcodeProjWrapperProtocol {
    var targets: [Target]
    var saveChangesCalled = false
    
    init(targets: [Target] = []) {
        self.targets = targets
    }
    
    func saveChanges() {
        saveChangesCalled = true
    }
    
}
