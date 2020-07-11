//
//  File.swift
//  
//
//  Created by Homero Oliveira on 08/07/20.
//

import XCTest
@testable import BumpCore

final class BumpTests: XCTestCase {
    
    func testBumpBuild() throws {
        let xcodeProj = XcodeProjWrapperMock()
        let bump = try Bump(xcodeProj: xcodeProj, bundleIdentifiers: ["test"])
    }
}
