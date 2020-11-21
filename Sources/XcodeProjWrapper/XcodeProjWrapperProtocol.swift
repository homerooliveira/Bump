//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import Foundation

public protocol XcodeProjWrapperProtocol {
    var targets: [Target] { get }

    func saveChanges() throws
}
