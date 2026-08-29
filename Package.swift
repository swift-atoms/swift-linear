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
        .library(
            name: "Linear",
            targets: ["Linear"]
        ),
        .library(
            name: "Linear Test Support",
            targets: ["Linear Test Support"]
        ),
    ],
    dependencies: [
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
            url: "https://github.com/swift-atoms/swift-numeric.git",
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
                .product(name: "Angle", package: "swift-angle"),
                .product(name: "Scale", package: "swift-scale"),
                .product(name: "Real", package: "swift-numeric"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "Linear Test Support",
            dependencies: [
                .target(name: "Linear"),
                .product(
                    name: "Tagged Test Support",
                    package: "swift-tagged"
                ),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Linear Tests",
            dependencies: [
                .target(name: "Linear"),
                .product(
                    name: "Tagged Standard Library Integration",
                    package: "swift-tagged"
                ),
                .target(name: "Linear Test Support"),
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
