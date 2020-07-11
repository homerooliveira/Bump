//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import Foundation
import XcodeProjWrapperInterface

final class XcodeProjWrapperMock: XcodeProjWrapperProtocol {

    var configsByTargetName: [String: [BuildConfiguration]] = [:]
    var saveChangesCalled = false
    
    func getConfigurationsByTargetName(bundleIdentifiers: Set<String>) -> [String : [BuildConfiguration]] {
        configsByTargetName
    }
    
    func saveChanges() {
        saveChangesCalled = true
    }
    
}
