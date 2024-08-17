import Foundation

public protocol XcodeProjFinderProtocol {
    func findXcodeProj(path: String) throws -> String
}

struct XcodeProjFinder: XcodeProjFinderProtocol {
    struct FindError: Error {
        let message: String

        init(_ message: String) {
            self.message = message
        }

        var description: String {
            message
        }
    }

    let fileManagerWrapper: FileManagerWrapperProtocol

    func findXcodeProj(path: String) throws -> String {
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

        guard let url = directoryContents.first(where: { $0.isXcodeProj }) else {
            throw FindError("Needs exist a .xcodeproj file in this directory.")
        }
        return url.path
    }
}

extension URL {
    public var isXcodeProj: Bool {
        pathExtension == "xcodeproj"
    }
}
