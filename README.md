# Linear

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Linear algebra types built from dimension and numeric concepts. Formatter behavior for tagged values is provided separately by `swift-tagged-formatter`.

## Installation

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-atoms/swift-linear.git", branch: "main")
]
```

> Pre-1.0: no version tags yet. APIs may change; pin a commit for reproducible builds.

Add the product to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Linear", package: "swift-linear")
    ]
)
```

Requires Swift 6.2+.

## License

Apache 2.0. See [LICENSE](LICENSE).
