//
//  File.swift
//  
//
//  Created by Homero Oliveira on 02/11/21.
//

import Foundation
import LoggerWrapper

public final class LoggerWrapperMock: LoggerWrapperProtocol {
    public private(set) var messages: [String] = []

    public init() {
    }

    public func log(message: String) {
        messages.append(message)
    }

    public func reset() {
        messages = []
    }
}
