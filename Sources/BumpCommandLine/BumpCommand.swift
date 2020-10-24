import ArgumentParser
import BumpCore
import Environment
import Foundation
import SwiftExtensions

struct BumpCommand: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        commandName: "bump",
        abstract: "Bump your projects."
    )
    
    @Argument(help: "Bundle Identifiers to search aplications/frameworks.")
    var bundleIdentifiers: [String]
    
    @Option(name: .shortAndLong, help: "Increment mode to bump version or build number. Either 'major', 'minor', 'patch', or 'build'.")
    var mode: IncrementMode
    
    @Option(name: .shortAndLong, help: "The path of .xcodeproj file or directory. Default value is the current directory.")
    var path = Current.fileManagerWrapper.currentDirectoryPath
    
    @Flag(name: .shortAndLong, help: "Show all the targets")
    var verbose = false
    
    @Flag(name: .shortAndLong, help: "Get the version of the first target and set it to the rest of the targets.")
    var useSameVersion = false
    
    mutating func validate() throws {
        guard !bundleIdentifiers.isEmpty else {
            throw ValidationError("Bundle Identifiers cannot be empty.")
        }
        
        if case .versionString(let version) = mode {
            let versionPattern = #"/^\d+\.\d+\.\d+(\.\d+)?$/"#
            let hasValidFormat = version.range(of: versionPattern, options: .regularExpression) != nil
            
            guard hasValidFormat else {
                throw ValidationError("Invalid format, the version must only have numbers and have two dots or three dots. Example of versions: `1.0.0` or `1.0.0.1`.")
            }
        }
    }
    
    func run() throws {
        let path = try findFirstXcodeProj()
        
        let bump = try Bump(
            xcodeProj: Current.xcodeProjWrapper(path),
            bundleIdentifiers: Set(bundleIdentifiers),
            log: Current.logger,
            isVerbose: verbose,
            useSameVersion: useSameVersion
        )
        
        try bump.bump(flag: mode)
    }
    
    private func findFirstXcodeProj() throws -> String  {
        guard Current.fileManagerWrapper.fileExists(atPath: path) else {
            throw ValidationError("Needs exist a path of .xcodeproj file or directory.")
        }
        
        guard let dirURL = URL(string: path) else {
            throw ValidationError("Wrong directory or path.")
        }
        
        if dirURL.isXcodeProj {
            return dirURL.path
        } else {
            guard dirURL.pathExtension.isEmpty else {
                throw ValidationError("The path must be .xcodeproj file or directory.")
            }
            
            let directoryContents = try Current.fileManagerWrapper.contentsOfDirectory(
                at: dirURL
            )
            
            guard let url = directoryContents.first(where: { $0.isXcodeProj }) else {
                throw ValidationError("Needs exist a .xcodeproj file in this directory.")
            }
            return url.path
        }
    }
}
