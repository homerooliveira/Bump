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

    init(
        fileManagerWrapper: FileManagerWrapperProtocol,
        xcodeProjWrapper: @escaping (String) throws -> XcodeProjWrapperProtocol,
        logger: @escaping (String) -> Void
    ) {
        self.fileManagerWrapper = fileManagerWrapper
        self.xcodeProjWrapper = xcodeProjWrapper
        self.logger = logger
    }
}

extension Environment {
    public static let live: Self = .init(
        fileManagerWrapper: FileManagerWrapper(), 
        xcodeProjWrapper: { try XcodeProjWrapper(path: $0) }, 
        logger: { print($0) }
    )
}