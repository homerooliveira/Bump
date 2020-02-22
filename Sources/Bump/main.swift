import BumpCore
import Foundation

let fileManager = FileManager.default

let dir = fileManager.currentDirectoryPath
do {
    guard let dirURL = URL(string: dir) else {
        throw MessageError(localizedDescription: "Wrong directory.")
    }
    
    let directoryContents = try fileManager.contentsOfDirectory(
        at: dirURL,
        includingPropertiesForKeys: nil
    )
    
    guard let url = directoryContents.first(where: { $0.pathExtension == "xcodeproj" }) else {
        throw MessageError(localizedDescription: "Needs exist a .xcodeproj file.")
    }
    
    let input = Array(CommandLine.arguments.dropFirst())
    let bundleIdentifier = input[0]
    
    if let flag = input
        .lazy
        .dropFirst()
        .compactMap(VersionArgs.init)
        .first {
        let bumper = try Bumper(
            path: url.path,
            bundleIdentifierPattern: bundleIdentifier
        )
        
        try bumper.bump(flag: flag)
    } else {
        
    }
} catch {
    print(error.localizedDescription)
}
