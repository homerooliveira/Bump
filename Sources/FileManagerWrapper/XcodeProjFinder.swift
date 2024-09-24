public import Foundation

public protocol XcodeProjFinderProtocol {
    func findXcodeProj(path: String?) throws -> String
}

public struct XcodeProjFinder: XcodeProjFinderProtocol {
    public struct FindError: Error, Equatable {
        let message: String

        init(_ message: String) {
            self.message = message
        }

        var description: String {
            message
        }
    }

    private let fileManagerWrapper: any FileManagerProtocol

    public init(fileManagerWrapper: any FileManagerProtocol) {
        self.fileManagerWrapper = fileManagerWrapper
    }

    public func findXcodeProj(path: String?) throws -> String {
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
