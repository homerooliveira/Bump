//
//  File.swift
//  
//
//  Created by Homero Oliveira on 24/10/20.
//

import FileManagerWrapper
import Foundation
import XcodeProjWrapper

public struct Environment {
    public let fileManagerWrapper: FileManagerWrapperProtocol
    public let xcodeProjWrapper: (String) throws -> XcodeProjWrapperProtocol
    public let logger: (String) -> Void
    
    public init(
        fileManagerWrapper: FileManagerWrapperProtocol = FileManagerWrapper(),
        xcodeProjWrapper: @escaping (String) throws -> XcodeProjWrapperProtocol = { try XcodeProjWrapper(path: $0) },
        logger: @escaping (String) -> Void = { print($0) }
    ) {
        self.fileManagerWrapper = fileManagerWrapper
        self.xcodeProjWrapper = xcodeProjWrapper
        self.logger = logger
    }
}
