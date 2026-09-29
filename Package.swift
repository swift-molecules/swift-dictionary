// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-dictionary",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Dictionary",
            targets: ["Dictionary"]
        ),
        .library(
            name: "Dictionary Standard Library Integration",
            targets: ["Dictionary Standard Library Integration"]
        ),
        .library(
            name: "Dictionary Apple Foundation Integration",
            targets: ["Dictionary Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-store.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-hash-table.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ownership-shared.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-buffer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer-linear.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-storage.git",
            branch: "main", traits: ["Generational", "Memory"]),
        .package(
            url: "https://github.com/swift-atoms/swift-memory.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-allocation.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Dictionary",
            dependencies: [
                .product(name: "Memory Allocator Protocol", package: "swift-memory-allocation"),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table"),
                .product(name: "Hash Table Primitive", package: "swift-hash-table"),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Buffer", package: "swift-buffer"),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Memory", package: "swift-memory"),
                .product(
                    name: "Memory Allocator",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Index", package: "swift-index"),
            ]
        ),
        .target(
            name: "Dictionary Standard Library Integration",
            dependencies: ["Dictionary"]
        ),
        .target(
            name: "Dictionary Apple Foundation Integration",
            dependencies: [
                "Dictionary",
                "Dictionary Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Dictionary Tests",
            dependencies: ["Dictionary",
                .product(name: "Storage", package: "swift-storage"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
