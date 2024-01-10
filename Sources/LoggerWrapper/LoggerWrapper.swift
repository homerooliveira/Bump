//
//  File.swift
//  
//
//  Created by Homero Oliveira on 02/11/21.
//

import Foundation
import Logging

public struct LoggerWrapper: LoggerWrapperProtocol {
    private let logger = Logger(label: "com.code.homero.Bump")

    public init() {
    }

    public func log(message: String) {
        #if DEBUG
        logger.info(.init(stringLiteral: message))
        #else
        print(message)
        #endif
    }

}
