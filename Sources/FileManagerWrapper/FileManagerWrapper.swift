//
//  File.swift
//  
//
//  Created by Homero Oliveira on 24/10/20.
//

import Foundation

extension FileManager: FileManagerProtocol {
    public func contentsOfDirectory(at url: URL) throws -> [URL] {
        try contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
    }
}