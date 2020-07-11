//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import Foundation

public protocol XcodeProjWrapperProtocol {
    func getConfigurationsByTargetName(bundleIdentifiers: Set<String>) -> [String: [BuildConfiguration]]
    func saveChanges() throws
}
