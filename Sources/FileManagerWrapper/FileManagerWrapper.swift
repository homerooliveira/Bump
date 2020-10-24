//
//  File.swift
//  
//
//  Created by Homero Oliveira on 24/10/20.
//

import Foundation

public final class FileManagerWrapper: FileManagerWrapperProtocol {
    private let fileManager: FileManager
    
    public var currentDirectoryPath: String {
        fileManager.currentDirectoryPath
    }
    
    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    public func fileExists(atPath path: String) -> Bool {
        fileManager.fileExists(atPath: path)
    }
    
    public func contentsOfDirectory(at url: URL) throws -> [URL] {
        try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
    }
}
