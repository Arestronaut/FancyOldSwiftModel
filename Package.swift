// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FancyOldSwiftModel",
    platforms: [
        .macOS("10.15.4")
    ],
    products: [
        .executable(name: "FancyOldSwiftModel", targets: ["FancyOldSwiftModel"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
        .package(url: "https://github.com/yanagiba/swift-ast.git", from: "0.19.9"),
    ],
    targets: [
        .target(
            name: "FancyOldSwiftModel",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftAST+Tooling", package: "swift-ast")
            ]
        ),
        .testTarget(
            name: "FancyOldSwiftModelTests",
            dependencies: ["FancyOldSwiftModel"]),
    ]
)
