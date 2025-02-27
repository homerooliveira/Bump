import Foundation

extension Array {
    @inlinable
    package subscript<T>(_ index: T) -> Element where T: RawRepresentable, T.RawValue == Index {
        get {
            self[index.rawValue]
        }
        set {
            self[index.rawValue] = newValue
        }
    }
}
