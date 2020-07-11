import ArgumentParser
import BumpCore
import Foundation
import XcodeProjWrapper

struct BumpCommand: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        commandName: "bump",
        abstract: "Bump your projects.",
        discussion: "When no files are specified, it expects the source from standard input."
    )
    
    @Argument(help: "Bundle Identifiers to search aplications/frameworks.")
    var bundleIdentifiers: [String]
    
    @Flag(help: "Increment mode to bump version or build number. Either 'major', 'minor', 'patch', or 'build'.")
    var mode: IncrementMode
        
    mutating func validate() throws {
        guard !bundleIdentifiers.isEmpty else {
            throw ValidationError("Bundle Identifier cannot be empty.")
        }
    }
    
    func run() throws {
        let path = try findFirstXcodeProj()
        
        let bump = try Bump(
            xcodeProj: XcodeProjWrapper(path: path),
            bundleIdentifiers: Set(bundleIdentifiers)
        )

        try bump.bump(flag: mode)
    }
    
    private func findFirstXcodeProj() throws -> String  {
        let fileManager = FileManager.default
        
        let dir = fileManager.currentDirectoryPath
        
        guard let dirURL = URL(string: dir) else {
            throw ValidationError("Wrong directory.")
        }
        
        let directoryContents = try fileManager.contentsOfDirectory(
            at: dirURL,
            includingPropertiesForKeys: nil
        )
        
        guard let url = directoryContents.first(where: { $0.pathExtension == "xcodeproj" }) else {
            throw ValidationError("Needs exist a .xcodeproj file.")
        }
        
        return url.path
    }
}

BumpCommand.main()
