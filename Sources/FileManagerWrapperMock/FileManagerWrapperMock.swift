//
//  File.swift
//  
//
//  Created by Homero Oliveira on 24/10/20.
//

import FileManagerWrapper
import Foundation

public final class FileManagerWrapperMock: FileManagerWrapperProtocol {
    public var currentDirectoryPath: String = ""

    public init() {}

    public var atPathPassed: String?
    public private(set) var fileExistsCalled = false
    public var fileExistsBeReturned = false

    public func fileExists(atPath: String) -> Bool {
        atPathPassed = atPath
        fileExistsCalled = true
        return fileExistsBeReturned
    }

    public var atURLPassed: URL?
    public private(set) var contentsOfDirectoryCalled = false
    public var contentsOfDirectoryBeReturned: [URL] = []

    public func contentsOfDirectory(at url: URL) throws -> [URL] {
        atURLPassed = url
        contentsOfDirectoryCalled = true
        return contentsOfDirectoryBeReturned
    }

    public func reset() {
        currentDirectoryPath = ""

        atPathPassed = nil
        fileExistsCalled = false
        fileExistsBeReturned = false

        atURLPassed = nil
        contentsOfDirectoryCalled = false
        contentsOfDirectoryBeReturned = []
    }
}
