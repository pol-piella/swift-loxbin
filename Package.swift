// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "loxbin",
    platforms: [.macOS(.v11)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.1"),
    ],
    targets: [
        .executableTarget(
            name: "loxbin",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")])
    ]
)
