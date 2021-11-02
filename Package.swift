// swift-tools-version:5.5
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
                 .upToNextMajor(from: "8.5.0")),
        .package(url: "https://github.com/apple/swift-argument-parser.git",
                 .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
    ],
    targets: [
        .executableTarget(name: "bump",
                          dependencies: ["BumpCommandLine"]),
        .target(
            name: "BumpCommandLine",
            dependencies: ["BumpCore",
                           .product(name: "ArgumentParser", package: "swift-argument-parser"),
                           "Environment"]),
        .target(
            name: "BumpCore",
            dependencies: ["SwiftExtensions", "LoggerWrapper", "XcodeProjWrapper",]),
        .target(name: "Environment",
                dependencies: ["FileManagerWrapper", "LoggerWrapper", "XcodeProjWrapper"]),
        .target(name: "FileManagerWrapper"),
        .target(
            name: "FileManagerWrapperMock",
            dependencies: ["FileManagerWrapper"]),
        .target(name: "SwiftExtensions"),
        .target(name: "LoggerWrapper",
                dependencies: [
                    .product(name: "Logging", package: "swift-log")]),
        .target(name: "LoggerWrapperMock", dependencies: ["LoggerWrapper"]),
        .target(
            name: "XcodeProjWrapper",
            dependencies: ["SwiftExtensions", "XcodeProj"]),
        .target(
            name: "XcodeProjWrapperMock",
            dependencies: ["XcodeProjWrapper"]),
        .testTarget(
            name: "BumpCoreTests",
            dependencies: ["BumpCore", "LoggerWrapperMock", "XcodeProjWrapperMock"]),
        .testTarget(
            name: "BumpCommandLineTests",
            dependencies: ["BumpCommandLine", "Environment", "FileManagerWrapperMock", "LoggerWrapperMock", "XcodeProjWrapperMock"]),
        .testTarget(
            name: "BumpCommandLineIntegrationTests",
            dependencies: ["BumpCommandLine", "Environment", "LoggerWrapperMock",]),
        .testTarget(
            name: "SwiftExtensionsTests",
            dependencies: ["SwiftExtensions"]),
    ]
)
