public import Hash_Indexed_Primitive
public import Hash

extension Hash {

    @frozen
    public struct Entry<Key: Hash.Key & ~Copyable, Value: ~Copyable>: ~Copyable {

        public let key: Key

        public var value: Value

        @inlinable
        public init(key: consuming Key, value: consuming Value) {
            self.key = key
            self.value = value
        }

        @inlinable
        public consuming func take() -> Value {
            value
        }
    }
}

extension Hash.Entry: Copyable where Key: Copyable, Value: Copyable {}

extension Hash.Entry: Sendable where Key: Sendable & ~Copyable, Value: Sendable & ~Copyable {}

extension Hash.Entry: Hash.`Protocol` where Key: ~Copyable, Value: ~Copyable {

    @inlinable
    public borrowing func hash(into hasher: inout Hasher) {
        key.hash(into: &hasher)
    }

    @inlinable
    public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.key == rhs.key
    }
}
