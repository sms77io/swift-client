// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "SevenClient",
        products: [
            .library(
                    name: "SevenClient",
                    targets: ["SevenClient"]),
        ],
        dependencies: [
            .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0"),
        ],
        targets: [
            .target(
                    name: "SevenClient",
                    dependencies: []),
            .testTarget(
                    name: "SevenClientTests",
                    dependencies: ["SevenClient"]),
        ]
)
