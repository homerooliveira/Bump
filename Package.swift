// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bump",
    platforms: [
        .macOS(.v10_11)
    ],
    products: [
        .executable(name: "bump", targets: ["Bump"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/tuist/xcodeproj.git",
                 .upToNextMajor(from: "7.10.0")),
        .package(url: "https://github.com/apple/swift-argument-parser",
                 from: "0.0.6"),
    ],
    targets: [
        .target(
            name: "Bump",
            dependencies: ["BumpCore", "ArgumentParser", "XcodeProjWrapper"]),
        .target(
            name: "BumpCore",
            dependencies: ["XcodeProjWrapper", "SwiftExtensions"]),
        .target(name: "SwiftExtensions"),
        .target(
            name: "XcodeProjWrapper",
            dependencies: ["SwiftExtensions", "XcodeProj"]),
        .testTarget(
            name: "BumpCoreTests",
            dependencies: ["BumpCore"]),
    ]
)
