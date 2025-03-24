// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Bump",
	platforms: [
		.macOS(.v13)
	],
	products: [
		.executable(name: "bump", targets: ["bump"]),
	],
	dependencies: [
		.package(
			url: "https://github.com/tuist/xcodeproj.git",
			.upToNextMajor(from: "9.0.0")),
		.package(
			url: "https://github.com/apple/swift-argument-parser.git",
			.upToNextMajor(from: "1.5.0")),
	],
	targets: [
		.executableTarget(name: "bump", dependencies: ["BumpCommandLine"]),
		.target(
			name: "BumpCommandLine",
			dependencies: [
				"BumpCore",
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				"Environment",
			]),
		.target(
			name: "BumpCore",
			dependencies: ["XcodeProjWrapper", "SwiftExtensions"]),
		.target(
			name: "Environment",
			dependencies: ["FileManagerWrapper", "XcodeProjWrapper"]),
		.target(name: "FileManagerWrapper"),
		.target(
			name: "FileManagerWrapperMock",
			dependencies: ["FileManagerWrapper"]),
		.target(name: "SwiftExtensions"),
		.target(
			name: "XcodeProjWrapper",
			dependencies: ["SwiftExtensions", .product(name: "XcodeProj", package: "xcodeproj")]),
		.target(
			name: "XcodeProjWrapperMock",
			dependencies: ["XcodeProjWrapper"]),
		.testTarget(
			name: "BumpCoreTests",
			dependencies: ["BumpCore", "XcodeProjWrapperMock"]),
		.testTarget(
			name: "BumpCommandLineTests",
			dependencies: [
				"BumpCommandLine", "Environment", "FileManagerWrapperMock", "XcodeProjWrapperMock",
			]),
		.testTarget(
			name: "BumpCommandLineIntegrationTests",
			dependencies: ["BumpCommandLine", "Environment"],
			resources: [.copy("Resources/")]
        ),
		.testTarget(
			name: "SwiftExtensionsTests",
			dependencies: ["SwiftExtensions"]),
		.testTarget(
			name: "FileManagerWrapperTests",
			dependencies: ["FileManagerWrapper", "FileManagerWrapperMock"]),
		.testTarget(
			name: "EnvironmentTests",
			dependencies: [
				"Environment",
				"FileManagerWrapper",
				"FileManagerWrapperMock",
				"XcodeProjWrapper",
				"XcodeProjWrapperMock",
			]),
	]
)

for target in package.targets {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .unsafeFlags(["-warnings-as-errors"]),
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
        ]
}
