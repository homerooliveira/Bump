//
//  File.swift
//  
//
//  Created by Homero Oliveira on 11/07/20.
//

import Foundation
import PathKit
import XcodeProj

public final class XcodeProjWrapper: XcodeProjWrapperProtocol {
    private let path: Path
    private let xcodeProj: XcodeProj

    public var targets: [Target] {
        xcodeProj.pbxproj.nativeTargets
    }

    public init(path: String) throws {
        self.path = Path(path)
        self.xcodeProj = try XcodeProj(path: self.path)
    }

    public func saveChanges() throws {
        try xcodeProj.writePBXProj(path: path, outputSettings: PBXOutputSettings())
    }
}
