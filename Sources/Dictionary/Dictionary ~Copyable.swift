public import Buffer
public import Index
public import Store
public import Cardinal
public import Tagged

extension __Dictionary where S: ~Copyable, S: Store.`Protocol` & Buffer.`Protocol` {

    @inlinable
    public var count: Tagged<S.Element, Cardinal> { store.count }

    @inlinable
    public var isEmpty: Bool { store.isEmpty }

    @inlinable
    public var capacity: Tagged<S.Element, Cardinal> { store.capacity }
}

extension __Dictionary where S: Copyable, S: Store.`Protocol` {

    @inlinable
    public borrowing func clone() -> Self {
        var result = copy self
        result.store.unshare()
        return result
    }
}
