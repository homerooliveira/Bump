//
//  URL+isXcodeProj.swift
//  
//
//  Created by Homero Oliveira on 27/07/20.
//

import Foundation

public extension URL {
    var isXcodeProj: Bool {
        pathExtension == "xcodeproj"
    }
}
