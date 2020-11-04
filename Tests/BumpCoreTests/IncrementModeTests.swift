//
//  File.swift
//  
//
//  Created by Homero Oliveira on 04/11/20.
//

import Foundation
import XCTest

@testable import BumpCore

final class IncrementModeTests: XCTestCase {
    
    func testRawValue() throws {
        let expectedValues = ["major", "minor", "patch", "build", "1.0.0"]
        
        let modes: [IncrementMode] = [.major, .minor, .patch, .build, .versionString("1.0.0")]
        
        XCTAssertEqual(expectedValues, modes.map { $0.rawValue })
    }
    
    func testInit() throws {
         let expectedModes: [IncrementMode] = [.major, .minor, .patch, .build, .versionString("1.0.0")]
         
         let values = ["major", "minor", "patch", "build", "1.0.0"]
        
        XCTAssertEqual(
            expectedModes,
            values.compactMap(IncrementMode.init(rawValue:))
        )
    }
}
