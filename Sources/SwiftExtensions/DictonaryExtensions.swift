import Foundation

extension Dictionary {
    @inlinable
    package subscript<T>(_ key: T) -> Value? where T: RawRepresentable, T.RawValue == Key {
        get {
            self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue
        }
    }
}
