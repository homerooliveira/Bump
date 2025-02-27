package import Foundation

extension FileManager: FileManagerProtocol {
    package func contentsOfDirectory(at url: URL) throws -> [URL] {
        try contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
    }
}
