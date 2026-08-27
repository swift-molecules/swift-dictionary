public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Hash_Indexed_Primitive
import Hash
public import Index
public import Memory_Allocator_Primitive
public import Memory_Heap
public import Ownership_Shared_Primitive
public import Storage_Contiguous
public import Storage_Primitive

extension __Dictionary where S: ~Copyable {

    @inlinable
    @discardableResult
    public mutating func insert<K: Hash.Key & ~Copyable, V: ~Copyable>(
        key: consuming K,
        value: consuming V
    ) -> V?
    where
        S == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
        >
    {
        if let slot = store.position(
            matching: key.hashValue,
            context: key,
            equals: { (candidate: borrowing Hash.Entry<K, V>, probe: borrowing K) in
                candidate.key == probe
            }
        ) {
            var displaced = consume value
            swap(&store[slot].value, &displaced)
            return displaced
        }
        _ = store.insert(Hash.Entry(key: key, value: value))
        return nil
    }

    @inlinable
    @discardableResult
    public mutating func insert<K: Hash.Key & ~Copyable, V: ~Copyable>(
        key: consuming K,
        value: consuming V
    ) -> V?
    where
        S == Ownership.Shared<
            Hash.Entry<K, V>,
            Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
            >
        >
    {
        store.withUnique(consuming: Hash.Entry(key: key, value: value)) { column, entry in
            if let slot = column.position(
                matching: entry.hashValue,
                context: entry,
                equals: {
                    (candidate: borrowing Hash.Entry<K, V>, probe: borrowing Hash.Entry<K, V>) in
                    candidate == probe
                }
            ) {

                var displaced = consume entry
                swap(&column[slot].value, &displaced.value)
                return displaced.take()
            }
            _ = column.insert(entry)
            return nil
        }
    }
}

extension __Dictionary where S: ~Copyable {

    @inlinable
    public func contains<K: Hash.Key & ~Copyable, V: ~Copyable>(key: borrowing K) -> Bool
    where
        S == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
        >
    {
        store.position(
            matching: key.hashValue,
            context: key,
            equals: { (candidate: borrowing Hash.Entry<K, V>, probe: borrowing K) in
                candidate.key == probe
            }
        ) != nil
    }

    @inlinable
    public func contains<K: Hash.Key & ~Copyable, V: ~Copyable>(key: borrowing K) -> Bool
    where
        S == Ownership.Shared<
            Hash.Entry<K, V>,
            Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
            >
        >
    {
        store.withColumn { column in
            column.position(
                matching: key.hashValue,
                context: key,
                equals: { (candidate: borrowing Hash.Entry<K, V>, probe: borrowing K) in
                    candidate.key == probe
                }
            ) != nil
        }
    }

    @inlinable
    public func withValue<K: Hash.Key & ~Copyable, V: ~Copyable, R>(
        forKey key: borrowing K,
        _ body: (borrowing V) -> R
    ) -> R?
    where
        S == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
        >
    {
        guard
            let slot = store.position(
                matching: key.hashValue,
                context: key,
                equals: { (candidate: borrowing Hash.Entry<K, V>, probe: borrowing K) in
                    candidate.key == probe
                }
            )
        else {
            return nil
        }
        return body(store[slot].value)
    }

    @inlinable
    public func withValue<K: Hash.Key & ~Copyable, V: ~Copyable, R>(
        forKey key: borrowing K,
        _ body: (borrowing V) -> R
    ) -> R?
    where
        S == Ownership.Shared<
            Hash.Entry<K, V>,
            Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
            >
        >
    {
        store.withColumn { column -> R? in
            guard
                let slot = column.position(
                    matching: key.hashValue,
                    context: key,
                    equals: { (candidate: borrowing Hash.Entry<K, V>, probe: borrowing K) in
                        candidate.key == probe
                    }
                )
            else {
                return nil
            }
            return body(column[slot].value)
        }
    }
}

extension __Dictionary where S: ~Copyable {

    @inlinable
    public mutating func withMutableValue<K: Hash.Key & ~Copyable, V: ~Copyable, R>(
        forKey key: borrowing K,
        _ body: (inout V) -> R
    ) -> R?
    where
        S == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
        >
    {
        guard
            let slot = store.position(
                matching: key.hashValue,
                context: key,
                equals: { (candidate: borrowing Hash.Entry<K, V>, probe: borrowing K) in
                    candidate.key == probe
                }
            )
        else {
            return nil
        }
        return body(&store[slot].value)
    }

    @inlinable
    public mutating func withMutableValue<K: Hash.Key & ~Copyable, V: ~Copyable, R>(
        forKey key: borrowing K,
        _ body: (inout V) -> R
    ) -> R?
    where
        S == Ownership.Shared<
            Hash.Entry<K, V>,
            Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
            >
        >
    {
        store.withUnique { column -> R? in
            guard
                let slot = column.position(
                    matching: key.hashValue,
                    context: key,
                    equals: { (candidate: borrowing Hash.Entry<K, V>, probe: borrowing K) in
                        candidate.key == probe
                    }
                )
            else {
                return nil
            }
            return body(&column[slot].value)
        }
    }
}

extension __Dictionary where S: ~Copyable {

    @inlinable
    public mutating func removeValue<K: Hash.Key & ~Copyable, V: ~Copyable>(
        forKey key: borrowing K
    ) -> V?
    where
        S == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
        >
    {
        guard
            let entry = store.remove(
                matching: key.hashValue,
                context: key,
                equals: { (candidate: borrowing Hash.Entry<K, V>, probe: borrowing K) in
                    candidate.key == probe
                }
            )
        else {
            return nil
        }
        return entry.take()
    }

    @inlinable
    public mutating func removeValue<K: Hash.Key & ~Copyable, V: ~Copyable>(
        forKey key: borrowing K
    ) -> V?
    where
        S == Ownership.Shared<
            Hash.Entry<K, V>,
            Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
            >
        >
    {
        store.withUnique { column -> V? in
            guard
                let entry = column.remove(
                    matching: key.hashValue,
                    context: key,
                    equals: { (candidate: borrowing Hash.Entry<K, V>, probe: borrowing K) in
                        candidate.key == probe
                    }
                )
            else {
                return nil
            }
            return entry.take()
        }
    }

    @inlinable
    public mutating func removeAll<K: Hash.Key & ~Copyable, V: ~Copyable>(
        keepingCapacity: Bool = true
    )
    where
        S == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
        >
    {
        store.removeAll(keepingCapacity: keepingCapacity)
    }

    @inlinable
    public mutating func removeAll<K: Hash.Key, V>(keepingCapacity: Bool = true)
    where
        S == Ownership.Shared<
            Hash.Entry<K, V>,
            Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
            >
        >
    {
        let capacity: Index.Index<Hash.Entry<K, V>>.Count =
            keepingCapacity ? store.capacity : .zero
        self.store = Ownership.Shared(
            Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
            >(minimumCapacity: capacity)
        )
    }

    @inlinable
    public mutating func removeAll<K: Hash.Key & ~Copyable, V: ~Copyable>(
        keepingCapacity: Bool = true
    )
    where
        S == Ownership.Shared<
            Hash.Entry<K, V>,
            Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
            >
        >
    {
        let capacity: Index.Index<Hash.Entry<K, V>>.Count =
            keepingCapacity ? store.capacity : .zero
        self.store = Ownership.Shared(
            Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
            >(minimumCapacity: capacity)
        )
    }
}

extension __Dictionary where S: ~Copyable {

    @inlinable
    public func forEach<K: Hash.Key & ~Copyable, V: ~Copyable>(
        _ body: (borrowing K, borrowing V) -> Void
    )
    where
        S == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
        >
    {
        store.forEach { entry in body(entry.key, entry.value) }
    }

    @inlinable
    public func forEach<K: Hash.Key & ~Copyable, V: ~Copyable>(
        _ body: (borrowing K, borrowing V) -> Void
    )
    where
        S == Ownership.Shared<
            Hash.Entry<K, V>,
            Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
            >
        >
    {
        store.withColumn { column in
            column.forEach { entry in body(entry.key, entry.value) }
        }
    }
}

extension __Dictionary where S: ~Copyable {

    @inlinable
    public func clone<K: Hash.Key, V>() -> Self
    where
        S == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
        >
    {
        Self(store: store.clone())
    }
}
