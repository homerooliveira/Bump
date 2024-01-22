//
//  File.swift
//  
//
//  Created by Homero Oliveira on 24/10/20.
//

import Foundation

/// This class is used to make it easier to test the code that uses FileManager.
/// Example of usage:
/// ```
/// let fileManager = FileManagerWrapper()
/// let exists = fileManager.fileExists(atPath: "path")
/// ```
///  - Note: This class is a wrapper for `FileManager`.
public final class FileManagerWrapper: FileManagerWrapperProtocol {
    private let fileManager: FileManager

    /// The current directory for the process.
    public var currentDirectoryPath: String {
        fileManager.currentDirectoryPath
    }

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    /// Checks if a file exists at the specified path.
    /// - Parameter path: The path of the file to check.
    /// - Returns: `true` if a file exists at the specified path, `false` otherwise.
    public func fileExists(atPath path: String) -> Bool {
        fileManager.fileExists(atPath: path)
    }

    /// Returns a list of URLs for the specified directory.
    /// - Parameter url: The URL for the directory whose contents you want to enumerate.
    /// - Returns: An array of NSURL objects, each of which identifies a file, directory, or symbolic link contained in url. Returns an empty array if the directory exists but has no contents. If an error occurs, this method returns nil and assigns an appropriate error object to the error parameter.
    /// - Throws: An error if the directory does not exist or there is some other error accessing it.
    public func contentsOfDirectory(at url: URL) throws -> [URL] {
        try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
    }
}
