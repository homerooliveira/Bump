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

extension Environment {
    public static let live = Self (
        fileManagerWrapper: FileManagerWrapper(),
        xcodeProjWrapper: { try XcodeProjWrapper(path: $0) },
        logger: { print($0) }
    )
}

// This extension is necessary to make Environment to be used in the BumpCommand as injected dependency.
extension Environment: Decodable {
    public init(from decoder: Decoder) throws {
        self = Self.live
    }
}
