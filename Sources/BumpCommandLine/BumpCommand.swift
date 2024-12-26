import ArgumentParser
import BumpCore
import Environment
import Foundation

package struct BumpCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "bump",
        abstract: "Bump your projects."
    )

    @Argument(help: "Bundle Identifiers to search aplications/frameworks.")
    var bundleIdentifiers: [String]

    @Option(name: .shortAndLong, help: "Increment mode to bump version or build number. Either 'major', 'minor', 'patch', or 'build'.")
    var mode: IncrementMode

    @Option(name: .shortAndLong, help: "The path of .xcodeproj file or directory. Default value is the current directory.")
    var path: String?

    @Flag(name: .shortAndLong, help: "Show all the targets")
    var verbose = false

    @Flag(name: .shortAndLong, help: "Get the version of the first target and set it to the rest of the targets.")
    var useSameVersion = false

    @Flag(inversion: .prefixedNo, help: "If set to true will override the targets versions of xcodeproj.")
    var inPlace: Bool = true

    var environment = Environment.live

    mutating func validate() throws {
        guard !bundleIdentifiers.isEmpty else {
            throw ValidationError("Bundle Identifiers cannot be empty.")
        }

        if case .versionString(let version) = mode {
            let versionPattern = /^\d+\.\d+\.\d+(?:\.\d+)?$/
            let hasValidFormat = try versionPattern.wholeMatch(in: version) != nil

            guard hasValidFormat else {
                throw ValidationError("Invalid format, the version must only have numbers and have two dots or three dots. Example of versions: `1.0.0` or `1.0.0.1`.")
            }
        }
    }

    func run() throws {
        let path = try environment.xcodeProjFinder.findXcodeProj(path: path)

        var bump = try Bump(
            xcodeProj: environment.xcodeProjWrapper(path),
            bundleIdentifiers: Set(bundleIdentifiers),
            log: environment.logger,
            isVerbose: verbose,
            useSameVersion: useSameVersion,
            inPlace: inPlace
        )

        try bump.bump(flag: mode)
    }
}
