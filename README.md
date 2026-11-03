# swift-dictionary

Use this package when you need a hash map whose keys and values may be `~Copyable`, with the copy behaviour chosen by the store. Start from `Dictionary<K, V>`: a move-only map that is never shared or copied implicitly. When you need copies with value semantics, use `__Dictionary<Ownership.Shared<Hash.Entry<K, V>, Hash.Indexed<Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear>>>`. Copies of it share one store until one of them is mutated. This package is unrelated to `Swift.Dictionary`. If you need to reach entries by position, use the sibling package swift-dictionary-ordered instead.

## Laws

- Hashing and equality of `Hash.Entry<Key, Value>` look only at the key. The value is ignored.
- `forEach` visits entries in the order they were first inserted. This order holds when the store grows and when entries are removed.
- `insert` on a key that is already present keeps the entry where it is. It also keeps the key instance that was stored first and drops the key just passed in. It returns the replaced value.
- `removeValue(forKey:)` keeps the remaining entries in their order by moving every later entry down one place. Its cost grows with the number of entries after the removed one.
- In the shared form, `insert`, `withMutableValue` and `removeValue(forKey:)` copy the store first whenever another copy still shares it. Other copies never see the change.
- In the shared form, `removeAll` always swaps in a new store and never clears the shared one. With `keepingCapacity`, the new store is given the old capacity.
- `clone()` returns a copy with its own store. Changes to either one never reach the other.
