//
//  File.swift
//  
//
//  Created by Homero Oliveira on 23/10/20.
//

import Foundation

public protocol FileManagerProtocol {
    var currentDirectoryPath: String { get }

    func fileExists(atPath: String) -> Bool
    func contentsOfDirectory(at url: URL) throws -> [URL]
}
