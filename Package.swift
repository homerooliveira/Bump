// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bump",
    platforms: [
        .macOS(.v10_11)
    ],
    products: [
        .executable(name: "bump", targets: ["bump"])
    ],
    dependencies: [
        .package(name: "XcodeProj",
                 url: "https://github.com/tuist/xcodeproj.git",
                 .upToNextMajor(from: "7.18.0")),
        .package(url: "https://github.com/apple/swift-argument-parser.git",
                 .upToNextMajor(from: "0.3.1")),
    ],
    targets: [
        .target(name: "bump",
            dependencies: ["BumpCommandLine"]),
        .target(
            name: "BumpCommandLine",
            dependencies: ["BumpCore",
                           .product(name: "ArgumentParser", package: "swift-argument-parser"),
                           "Environment"]),
        .target(
            name: "BumpCore",
            dependencies: ["XcodeProjWrapper", "SwiftExtensions"]),
        .target(name: "Environment",
                dependencies: ["FileManagerWrapper", "XcodeProjWrapper"]),
        .target(name: "FileManagerWrapper"),
        .target(
            name: "FileManagerWrapperMock",
            dependencies: ["FileManagerWrapper"]),
        .target(name: "SwiftExtensions"),
        .target(
            name: "XcodeProjWrapper",
            dependencies: ["SwiftExtensions", "XcodeProj"]),
        .target(
            name: "XcodeProjWrapperMock",
            dependencies: ["XcodeProjWrapper"]),
        .testTarget(
            name: "BumpCoreTests",
            dependencies: ["BumpCore", "XcodeProjWrapperMock"]),
        .testTarget(
            name: "BumpCommandLineTests",
            dependencies: ["BumpCommandLine", "Environment", "FileManagerWrapperMock", "XcodeProjWrapperMock"]),
        .testTarget(
            name: "BumpCommandLineIntegrationTests",
            dependencies: ["BumpCommandLine", "Environment", "SwiftExtensions"]),
        .testTarget(
            name: "SwiftExtensionsTests",
            dependencies: ["SwiftExtensions"]),
    ]
)
