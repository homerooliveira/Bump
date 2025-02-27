import Foundation

package protocol XcodeProjFinderProtocol {
    func findXcodeProj(path: String?) throws -> String
}

package struct XcodeProjFinder: XcodeProjFinderProtocol {
    package struct FindError: Error, Equatable {
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
        let path = path ?? fileManagerWrapper.currentDirectoryPath

        guard fileManagerWrapper.fileExists(atPath: path) else {
            throw FindError("Needs exist a path of .xcodeproj file or directory.")
        }

        guard let dirURL = URL(string: path) else {
            throw FindError("Wrong directory or path.")
        }

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
