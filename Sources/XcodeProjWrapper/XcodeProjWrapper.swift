private import PathKit
import XcodeProj
import Foundation

package struct XcodeProjWrapper: XcodeProjWrapperProtocol {
    private let path: Path
    private let xcodeProj: XcodeProj

    package var targets: [Target]

    package init(path: String) throws {
        self.path = Path(path)
        self.xcodeProj = try XcodeProj(path: self.path)
        self.targets = xcodeProj.pbxproj.nativeTargets.map { target in
            Target(target: target)
        }
    }

    package func saveChanges() throws {
        try xcodeProj.writePBXProj(path: path, outputSettings: PBXOutputSettings())
    }
}
