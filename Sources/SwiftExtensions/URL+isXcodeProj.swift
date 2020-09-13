//
//  URL+isXcodeProj.swift
//  
//
//  Created by Homero Oliveira on 27/07/20.
//

import Foundation

extension URL {
    public var isXcodeProj: Bool {
        pathExtension == "xcodeproj"
    }
}
