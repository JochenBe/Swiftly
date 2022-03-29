// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "Swiftly",
    products: [
        .executable(
            name: "Swiftly",
            targets: ["Swiftly"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/JochenBe/Shell", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "Swiftly",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Shell"
            ]),
        .testTarget(
            name: "SwiftlyTests",
            dependencies: ["Swiftly"]),
    ]
)
