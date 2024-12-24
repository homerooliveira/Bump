import Foundation

public protocol FileManagerProtocol {
    var currentDirectoryPath: String { get }

    func fileExists(atPath: String) -> Bool
    func contentsOfDirectory(at url: URL) throws -> [URL]
}
