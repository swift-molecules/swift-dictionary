public import Buffer_Protocol
public import Dictionary_Primitive
public import Index
public import Store_Protocol

extension __Dictionary where S: ~Copyable, S: Store.`Protocol` & Buffer.`Protocol` {

    @inlinable
    public var count: Index.Index<S.Element>.Count { store.count }

    @inlinable
    public var isEmpty: Bool { store.isEmpty }

    @inlinable
    public var capacity: Index.Index<S.Element>.Count { store.capacity }
}

extension __Dictionary where S: Copyable, S: Store.`Protocol` {

    @inlinable
    public borrowing func clone() -> Self {
        var result = copy self
        result.store.unshare()
        return result
    }
}
