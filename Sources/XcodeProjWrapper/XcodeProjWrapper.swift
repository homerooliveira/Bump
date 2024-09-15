private import PathKit
internal import XcodeProj
import Foundation

public struct XcodeProjWrapper: XcodeProjWrapperProtocol {
    private let path: Path
    private let xcodeProj: XcodeProj

    public var targets: [any Target]

    public init(path: String) throws {
        self.path = Path(path)
        self.xcodeProj = try XcodeProj(path: self.path)
        self.targets = xcodeProj.pbxproj.nativeTargets.map { target in
            TargetWrapper(target: target)
        }
    }

    public func saveChanges() throws {
        try xcodeProj.writePBXProj(path: path, outputSettings: PBXOutputSettings())
    }
}
