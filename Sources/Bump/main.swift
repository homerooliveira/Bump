import ArgumentParser
import BumpCore
import Foundation

struct BumpCommand: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        commandName: "bump",
        abstract: "Bump your projects.",
        discussion: "When no files are specified, it expects the source from standard input."
    )
    
    @Argument(help: "Bundle Identifier to search aplications/frameworks.")
    var bundleIdentifier: String
    
    @Argument(help: "Increment mode to bump version or build number. Either 'major', 'minor', 'patch', or 'build'.")
    var mode: IncrementMode
    
    @Flag(help: "Show all the targets incremented.")
    var verbose: Bool
    
    var url: URL!
    
    mutating func validate() throws {
        guard !bundleIdentifier.isEmpty else {
            throw ValidationError("Bundle Identifier cannot be empty.")
        }
        
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
        
        self.url = url
    }
    
    func run() throws {
        let bumper = try Bumper(
            path: url.path,
            bundleIdentifierPattern: bundleIdentifier
        )
        
        try bumper.bump(flag: mode)
    }
}

BumpCommand.main()
