final class Box<T>: Equatable where T: Equatable {
    var value: T

    init(_ value: T) {
        self.value = value
    }

    static func == (lhs: Box<T>, rhs: Box<T>) -> Bool {
        lhs.value == rhs.value
    }
}
