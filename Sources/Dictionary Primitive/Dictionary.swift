public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Hash_Indexed_Primitive
import Hash_Primitives
public import Index_Primitives
public import Memory_Allocator_Primitive
public import Memory_Heap_Primitives
public import Ownership_Shared_Primitive
public import Storage_Contiguous_Primitives
public import Storage_Primitive

@_documentation(visibility: public)
@frozen
public struct __Dictionary<S: ~Copyable>: ~Copyable {

    @usableFromInline
    package var store: S

    @inlinable
    public init(store: consuming S) {
        self.store = store
    }

    @inlinable
    public consuming func take() -> S {
        store
    }
}

extension __Dictionary: Copyable where S: Copyable {}

extension __Dictionary: Sendable where S: Sendable & ~Copyable {}

extension __Dictionary where S: ~Copyable {

    @inlinable
    public init<K: Hash.Key & ~Copyable, V: ~Copyable>(
        minimumCapacity: Index_Primitives.Index<Hash.Entry<K, V>>.Count = .zero
    )
    where
        S == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
        >
    {
        self.init(store: S(minimumCapacity: minimumCapacity))
    }

    @inlinable
    public init<K: Hash.Key, V>(
        minimumCapacity: Index_Primitives.Index<Hash.Entry<K, V>>.Count = .zero
    )
    where
        S == Ownership.Shared<
            Hash.Entry<K, V>,
            Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
            >
        >
    {
        self.init(
            store: Ownership.Shared(
                Hash.Indexed<
                    Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>
                        .Linear
                >(minimumCapacity: minimumCapacity)
            )
        )
    }

    @inlinable
    public init<K: Hash.Key & ~Copyable, V: ~Copyable>(
        minimumCapacity: Index_Primitives.Index<Hash.Entry<K, V>>.Count = .zero
    )
    where
        S == Ownership.Shared<
            Hash.Entry<K, V>,
            Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
            >
        >
    {
        self.init(
            store: Ownership.Shared(
                Hash.Indexed<
                    Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>
                        .Linear
                >(minimumCapacity: minimumCapacity)
            )
        )
    }
}
