public import Foundation

extension FileManager: FileManagerProtocol {
    public func contentsOfDirectory(at url: URL) throws -> [URL] {
        try contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
    }
}
