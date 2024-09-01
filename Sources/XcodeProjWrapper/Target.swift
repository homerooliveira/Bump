//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import Foundation

public protocol Target {
    var name: String { get }
    var buildConfigurations: [any BuildConfiguration] { get }
}
