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
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "7.8.0"))
    ],
    targets: [
        .target(
            name: "Bump",
            dependencies: ["BumpCore"]),
        .target(
            name: "BumpCore",
            dependencies: ["XcodeProj"]),
        .testTarget(
            name: "BumpTests",
            dependencies: ["Bump"]),
    ]
)
