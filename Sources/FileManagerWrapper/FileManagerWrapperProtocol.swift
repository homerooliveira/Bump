package import Foundation

package protocol FileManagerProtocol {
    var currentDirectoryPath: String { get }

    func fileExists(atPath: String) -> Bool
    func contentsOfDirectory(at url: URL) throws -> [URL]
}
