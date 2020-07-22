import ArgumentParser
import BumpCore
import Foundation
import XcodeProjWrapper

private let fileManager = FileManager.default

struct BumpCommand: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        commandName: "bump",
        abstract: "Bump your projects.",
        discussion: "When no files are specified, it expects the source from standard input."
    )
    
    @Argument(help: "Bundle Identifiers to search aplications/frameworks.")
    var bundleIdentifiers: [String]
    
    @Option(help: "Increment mode to bump version or build number. Either 'major', 'minor', 'patch', or 'build'.")
    var mode: IncrementMode
    
    @Option(default: fileManager.currentDirectoryPath, help: "The path of .xcodeproj file or directory.")
    var path: String
    
    mutating func validate() throws {
        guard !bundleIdentifiers.isEmpty else {
            throw ValidationError("Bundle Identifiers cannot be empty.")
        }
    }
    
    func run() throws {
        let path = try findFirstXcodeProj()
        
        let bump = try Bump(
            xcodeProj: XcodeProjWrapper(path: path),
            bundleIdentifiers: Set(bundleIdentifiers),
            log: { print($0) }
        )
        
        try bump.bump(flag: mode)
    }
    
    private func findFirstXcodeProj() throws -> String  {
        guard fileManager.fileExists(atPath: path) else {
            throw ValidationError("The path must exist.")
        }
        
        guard let dirURL = URL(string: path) else {
            throw ValidationError("Wrong directory or path.")
        }
        
        if case .versionString(let version) = mode {
            let dotsCount = version.lazy.filter({ $0 == "." }).count
            if dotsCount < 3 && dotsCount > 4 {
                throw ValidationError("Invalid format of the version, the version must have three dots or four dots. Example of versions: `1.0.0` or `1.0.0.1`.")
            }
        }
        
        if dirURL.isXcodeProj {
            return dirURL.path
        } else {
            guard dirURL.pathExtension.isEmpty else {
                throw ValidationError("The path must be .xcodeproj file or directory.")
            }
            
            let directoryContents = try fileManager.contentsOfDirectory(
                at: dirURL,
                includingPropertiesForKeys: nil
            )
            
            guard let url = directoryContents.first(where: { $0.isXcodeProj }) else {
                throw ValidationError("Needs exist a .xcodeproj file in this directory.")
            }
            return url.path
        }
    }
}

extension URL {
    var isXcodeProj: Bool {
        pathExtension == "xcodeproj"
    }
}
