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
            name: "Linear Standard Library Integration",
            targets: ["Linear Standard Library Integration"]
        ),
        .library(
            name: "Linear Apple Foundation Integration",
            targets: ["Linear Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-dimension.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-numeric.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Linear",
            dependencies: [
                .product(name: "Dimension", package: "swift-dimension"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Numeric", package: "swift-numeric"),
                .product(
                    name: "Numeric Standard Library Integration",
                    package: "swift-numeric"
                ),
            ]
        ),
        .target(
            name: "Linear Standard Library Integration",
            dependencies: ["Linear"]
        ),
        .target(
            name: "Linear Apple Foundation Integration",
            dependencies: [
                "Linear",
                "Linear Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Linear Tests",
            dependencies: ["Linear"]
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
