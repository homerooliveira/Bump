import Foundation
import XCTest

func fixturesPath() throws -> URL {
    try XCTUnwrap(Bundle.module.resourceURL)
}
