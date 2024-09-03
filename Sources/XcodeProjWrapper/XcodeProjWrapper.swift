private import PathKit
private import XcodeProj
import Foundation

public struct XcodeProjWrapper: XcodeProjWrapperProtocol {
    private let path: Path
    private let xcodeProj: XcodeProj

    public var targets: [any Target] {
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
