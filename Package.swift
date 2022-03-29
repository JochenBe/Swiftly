// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "swiftly",
    products: [
        .executable(
            name: "swiftly",
            targets: ["swiftly"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "swiftly",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "swiftlyTests",
            dependencies: ["swiftly"]),
    ]
)
