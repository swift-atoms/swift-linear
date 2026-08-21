// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-linear-primitives",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Linear Primitives",
            targets: ["Linear Primitives"]
        ),
        .library(
            name: "Linear Primitives Test Support",
            targets: ["Linear Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-dimension-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-format-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-numeric-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-tagged-primitives.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Linear Primitives",
            dependencies: [
                .product(name: "Dimension Primitives", package: "swift-dimension-primitives"),
                .product(name: "Format Primitives", package: "swift-format-primitives"),
                .product(name: "Real Primitives", package: "swift-numeric-primitives"),
            ]
        ),
        .target(
            name: "Linear Primitives Test Support",
            dependencies: [
                "Linear Primitives",
                .product(
                    name: "Tagged Primitives Test Support",
                    package: "swift-tagged-primitives"
                ),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Linear Primitives Tests",
            dependencies: [
                "Linear Primitives",
                .product(
                    name: "Tagged Primitives Standard Library Integration",
                    package: "swift-tagged-primitives"
                ),
                "Linear Primitives Test Support",
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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
