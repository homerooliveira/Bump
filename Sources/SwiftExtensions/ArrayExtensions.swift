//
//  File.swift
//  
//
//  Created by Homero Oliveira on 08/07/20.
//

import Foundation

extension Array {
    public subscript<T>(_ index: T) -> Element where T: RawRepresentable, T.RawValue == Index {
        get {
            self[index.rawValue]
        }
        set {
            self[index.rawValue] = newValue
        }
    }

    public subscript<T>(_ range: Range<T>) -> ArraySlice<Element> where T: RawRepresentable, T: Comparable, T.RawValue == Index {
        self[range.lowerBound.rawValue..<range.upperBound.rawValue]
    }
    
    public subscript<T>(_ range: ClosedRange<T>) -> ArraySlice<Element> where T: RawRepresentable, T.RawValue == Index, T: Comparable {
        self[range.lowerBound.rawValue...range.upperBound.rawValue]
    }

    public subscript<T>(_ range: PartialRangeFrom<T>) -> ArraySlice<Element> where T: RawRepresentable, T.RawValue == Index, T: Comparable {
        self[range.lowerBound.rawValue...]
    }

    public subscript<T>(_ range: PartialRangeUpTo<T>) -> ArraySlice<Element> where T: RawRepresentable, T.RawValue == Index, T: Comparable {
        self[..<range.upperBound.rawValue]
    }

    public subscript<T>(_ range: PartialRangeThrough<T>) -> ArraySlice<Element> where T: RawRepresentable, T.RawValue == Index, T: Comparable {
        self[...range.upperBound.rawValue]
    }
}
