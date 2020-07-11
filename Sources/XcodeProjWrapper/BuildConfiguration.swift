//
//  File 2.swift
//  
//
//  Created by Homero Oliveira on 08/07/20.
//

import Foundation

public protocol BuildConfiguration: AnyObject {
    var bundleIdentifier: String { get }
    var buildNumber: String? { get set }
    var version: String? { get set }
}
