public import Buffer_Linear_Primitive
public import Buffer
public import Hash_Indexed_Primitive
import Hash
public import Memory_Allocator
public import Memory
public import Storage_Memory

public typealias Dictionary<K: Hash.Key & ~Copyable, V: ~Copyable> =
    __Dictionary<
        Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
        >
    >
