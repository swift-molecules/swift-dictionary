public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Hash_Indexed_Primitive
import Hash
public import Memory_Allocator_Primitive
public import Memory
public import Storage_Contiguous

public typealias Dictionary<K: Hash.Key & ~Copyable, V: ~Copyable> =
    __Dictionary<
        Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear
        >
    >
