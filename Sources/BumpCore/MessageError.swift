//
//  File.swift
//  
//
//  Created by Homero Oliveira on 21/02/20.
//

import Foundation

public struct MessageError: Error {
    public var localizedDescription: String
    
    public init(localizedDescription: String) {
        self.localizedDescription = localizedDescription
    }
}
