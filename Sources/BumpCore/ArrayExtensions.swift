//
//  File.swift
//  
//
//  Created by Homero Oliveira on 08/07/20.
//

import Foundation

public extension Array {
    subscript<T>(_ index: T) -> Element where T: RawRepresentable, T.RawValue == Index {
        get {
            self[index.rawValue]
        }
        set {
            self[index.rawValue] = newValue
        }
    }
}
