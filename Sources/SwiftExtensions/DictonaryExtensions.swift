import Foundation

extension Dictionary {
    @inlinable
    public subscript<T>(_ key: T) -> Value? where T: RawRepresentable, T.RawValue == Key {
        get {
            self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue
        }
    }
}
