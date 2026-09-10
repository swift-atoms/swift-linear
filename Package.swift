// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-linear",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Linear", targets: ["Linear"]),
        .library(name: "Linear Standard Library Integration", targets: ["Linear Standard Library Integration"]),
        .library(name: "Linear Foundation Library Integration", targets: ["Linear Foundation Library Integration"]),
        .library(name: "Linear Test Support", targets: ["Linear Test Support"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-vector.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-matrix.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-spatial.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-angle.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-scale.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-trigonometry.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Linear",
            dependencies: [
                .product(name: "Spatial", package: "swift-spatial"),
                .product(name: "Vector", package: "swift-vector"),
                .product(name: "Matrix", package: "swift-matrix"),
                .product(name: "Angle", package: "swift-angle"),
                .product(name: "Scale", package: "swift-scale"),
                .product(name: "Trigonometry", package: "swift-trigonometry"),
                .product(name: "Tagged", package: "swift-tagged"),
            ],
            path: "Sources/Linear"
        ),
        .target(
            name: "Linear Standard Library Integration",
            dependencies: [
                .target(name: "Linear"),
            ],
            path: "Sources/Linear Standard Library Integration"
        ),
        .target(
            name: "Linear Foundation Library Integration",
            dependencies: [
                .target(name: "Linear"),
                .target(name: "Linear Standard Library Integration"),
            ],
            path: "Sources/Linear Foundation Library Integration"
        ),
        .target(
            name: "Linear Test Support",
            dependencies: [
                .target(name: "Linear"),
                .product(name: "Tagged Test Support", package: "swift-tagged"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Linear Tests",
            dependencies: [
                .target(name: "Linear"),
                .product(name: "Trigonometry", package: "swift-trigonometry"),
                .product(name: "Tagged", package: "swift-tagged"),
                .target(name: "Linear Test Support"),
                .target(name: "Linear Standard Library Integration"),
                .target(name: "Linear Foundation Library Integration"),
            ],
            path: "Tests/Linear Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
