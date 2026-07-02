# ``Dictionary_Primitives``

@Metadata {
    @DisplayName("Dictionary Primitives")
    @TitleHeading("Swift Primitives")
}

An insertion-ordered hash dictionary generic over its storage column: the carrier `__Dictionary<S>` (front door `Dictionary<K, V>`) maps keys to values over an ordered hashed column of key-projected entries, with copyability flowing from the column (move-only by default, opt-in copy-on-write via `Shared`).

## Topics
