//
//  
//
//  Created by Homero Oliveira on 08/07/20.
//

import Foundation

extension Dictionary {
    public subscript<T>(_ key: T) -> Value? where T: RawRepresentable, T.RawValue == Key {
        get {
            self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue
        }
    }
}
