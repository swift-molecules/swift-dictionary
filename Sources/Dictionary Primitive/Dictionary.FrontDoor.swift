// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Hash_Indexed_Primitive
public import Hash_Primitives
public import Memory_Allocator_Primitive
public import Memory_Heap_Primitives
public import Storage_Contiguous_Primitives

// MARK: - Dictionary<K, V> — the CANONICAL front door ([DS-028])

/// An insertion-ordered hash dictionary over the default column: the growable,
/// heap-allocated, move-only ordered hashed entry column.
///
/// This is the canonical front-door alias ([DS-028]) — the sanctioned
/// [API-NAME-004] generic-instantiation exception that pins the default column so
/// consumers spell `Dictionary<Key, Value>`, never the carrier `__Dictionary` or a
/// full column. The alias fully specializes: conformances, the pinned constructors,
/// and `~Copyable` keys/values all flow through it with zero forwarding and zero
/// runtime cost.
///
/// ```swift
/// var d = Dictionary<Int, Int>()   // growable move-only (this alias)
/// d.insert(key: 1, value: 10)
/// ```
///
/// The insertion-ordered positional surface is the sibling `Dictionary<K, V>.Ordered`
/// (`Dictionary Ordered Primitive`); the `Shared` (CoW) ownership variant is
/// consumer-pulled and lands as it gains a live consumer.
///
/// This shadows `Swift.Dictionary`. Use `Swift.Dictionary` for the stdlib type when
/// both are in scope.
public typealias Dictionary<K: Hash.Key & ~Copyable, V: ~Copyable> =
    __Dictionary<Hash.Indexed<Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Hash.Entry<K, V>>>.Linear>>
