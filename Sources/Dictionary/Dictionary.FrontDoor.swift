public import Buffer_Linear_Primitive
public import Buffer
public import Hash_Indexed_Primitive
public import Hash_Table_Primitive
public import Memory_Allocator
public import Memory
public import Storage

public typealias Dictionary<K: Swift.Hashable & ~Copyable, V: ~Copyable> =
    __Dictionary<
        Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
        >
    >
