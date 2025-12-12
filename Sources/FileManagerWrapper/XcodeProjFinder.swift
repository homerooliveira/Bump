import Foundation

package protocol XcodeProjFinderProtocol {
    func findXcodeProj(path: String?) throws -> String
}

package struct XcodeProjFinder: XcodeProjFinderProtocol {
    package struct FindError: Error, Equatable, Sendable {
        // periphery:ignore - Because the periphery can't find the usage of this property.
        let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    private let fileManagerWrapper: any FileManagerProtocol

    package init(fileManagerWrapper: any FileManagerProtocol) {
        self.fileManagerWrapper = fileManagerWrapper
    }

    package func findXcodeProj(path: String?) throws -> String {
        let providedPath = path ?? fileManagerWrapper.currentDirectoryPath
        let expandedPath = (providedPath as NSString).expandingTildeInPath

        guard !expandedPath.isEmpty else {
            throw FindError("Wrong directory or path.")
        }

        guard fileManagerWrapper.fileExists(atPath: expandedPath) else {
            throw FindError("Needs exist a path of .xcodeproj file or directory.")
        }

        let dirURL = URL(fileURLWithPath: expandedPath).standardizedFileURL

        if dirURL.isXcodeProj {
            return dirURL.path
        }
        guard dirURL.pathExtension.isEmpty else {
            throw FindError("The path must be .xcodeproj file or directory.")
        }

        let directoryContents = try fileManagerWrapper.contentsOfDirectory(
            at: dirURL
        )

        guard let url = directoryContents.first(where: \.isXcodeProj) else {
            throw FindError("Needs exist a .xcodeproj file in this directory.")
        }
        return url.path
    }
}

extension URL {
    var isXcodeProj: Bool {
        pathExtension == "xcodeproj"
    }
}
