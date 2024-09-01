internal import Foundation
internal import SwiftExtensions
import XcodeProjWrapper

public struct Bump {
    private let xcodeProj: any XcodeProjWrapperProtocol
    private let bundleIdentifiers: Set<String>
    private let log: (String) -> Void
    private let isVerbose: Bool
    private let useSameVersion: Bool
    private let inPlace: Bool

    public init(
        xcodeProj: any XcodeProjWrapperProtocol,
        bundleIdentifiers: Set<String>,
        log: @escaping (String) -> Void,
        isVerbose: Bool,
        useSameVersion: Bool,
        inPlace: Bool
    ) throws {
        self.xcodeProj = xcodeProj
        self.bundleIdentifiers = bundleIdentifiers
        self.log = log
        self.isVerbose = isVerbose
        self.useSameVersion = useSameVersion
        self.inPlace = inPlace
    }

    public func bump(flag: IncrementMode) throws {
        let configsByTargetName = getConfigurationsByTargetName()

        if useSameVersion {
            let configs = configsByTargetName.values
                .lazy
                .flatMap { $0 }

            guard let config = configs.first else { return }

            let oldBuildNumber = config.buildNumber ?? ""
            applyBump(configuration: config, flag: flag)
            let buildNumber = config.buildNumber ?? ""

            if isVerbose {
                let allTargets = configsByTargetName.keys.joined(separator: ", ")
                log(allTargets)
                log("\(oldBuildNumber) -> \(buildNumber)")
            } else {
                log(buildNumber)
            }

            let versionFlag: IncrementMode = .versionString(buildNumber)

            for config in configs.dropFirst() {
                applyBump(configuration: config, flag: versionFlag)
            }
        } else {
            for (targetName, configs) in configsByTargetName {
                guard let config = configs.first else { continue }

                let oldBuildNumber = config.buildNumber ?? ""
                applyBump(configuration: config, flag: flag)
                let buildNumber = config.buildNumber ?? ""

                if isVerbose {
                    let targetOutput = "\(targetName) \(oldBuildNumber) -> \(buildNumber)"
                    log(targetOutput)
                } else {
                    log(buildNumber)
                }

                for config in configs.dropFirst() {
                    applyBump(configuration: config, flag: flag)
                }
            }
        }

        if inPlace {
            try xcodeProj.saveChanges()
        }
    }

    func getConfigurationsByTargetName() -> [String: [any BuildConfiguration]] {
        var configsByTargetName: [String: [any BuildConfiguration]] = [:]

        for target in xcodeProj.targets {
            let configurations = target.buildConfigurations

            for configuration in configurations {
                let bundleIdentifierOfConfig = configuration.bundleIdentifier
                if bundleIdentifiers.contains(where: bundleIdentifierOfConfig.starts(with:))
                    || bundleIdentifiers.contains("all") {
                    configsByTargetName[target.name, default: []].append(configuration)
                }
            }
        }

        return configsByTargetName
    }

    func applyBump(configuration: some BuildConfiguration, flag: IncrementMode) {
        switch flag {
        case .major:
            bumpMajorVersion(from: configuration)

        case .minor:
            bumpMinorVersion(from: configuration)

        case .patch:
            bumpPatchVersion(from: configuration)

        case .build:
            bumpBuildVersion(from: configuration)

        case .versionString(let version):
            setVersion(version, from: configuration)
        }
    }

    private func bumpMajorVersion(from configuration: some BuildConfiguration) {
        changeVersionsNumbers(from: configuration) { versionNumbers in
            let major = Int(versionNumbers[VersionIndex.major]) ?? 0
            versionNumbers[VersionIndex.major] = "\(major + 1)"
            versionNumbers[VersionIndex.minor] = "0"
            versionNumbers[VersionIndex.patch] = "0"
        }
    }

    private func bumpMinorVersion(from configuration: some BuildConfiguration) {
        changeVersionsNumbers(from: configuration) { versionNumbers in
            let minor = Int(versionNumbers[VersionIndex.minor]) ?? 0
            versionNumbers[VersionIndex.minor] = "\(minor + 1)"
            versionNumbers[VersionIndex.patch] = "0"
        }
    }

    private func bumpPatchVersion(from configuration: some BuildConfiguration) {
        changeVersionsNumbers(from: configuration) { versionNumbers in
            let patch = Int(versionNumbers[VersionIndex.patch]) ?? 0
            versionNumbers[VersionIndex.patch] = "\(patch + 1)"
        }
    }

    private func changeVersionsNumbers(
        from configuration: some BuildConfiguration,
        transform: (inout [Substring]) -> Void
    ) {
        var versionArray: [Substring] = getVersion(from: configuration)
        transform(&versionArray)
        let version = versionArray.joined(separator: ".")
        configuration.version = version
        configuration.buildNumber = "\(version).1"
    }

    private func bumpBuildVersion(from configuration: some BuildConfiguration) {
        let version = getVersion(from: configuration).joined(separator: ".")
        let buildNumber = configuration.buildNumber?
            .split(separator: ".")
            .last
            .flatMap { Int($0) } ?? 0
        configuration.version = version
        configuration.buildNumber = "\(version).\(buildNumber + 1)"
    }

    private func getVersion(from configuration: some BuildConfiguration) -> [Substring] {
        guard let version = configuration.version?.split(separator: ".") else {
            return ["0", "0", "0"]
        }

        if version.count >= 3 {
            return Array(version.prefix(3))
        }

        return version + Array(repeating: "0", count: 3 - version.count)
    }

    private func setVersion(_ version: String, from configuration: some BuildConfiguration) {
        let versionArray = version.split(separator: ".")

        if versionArray.count == 3 {
            configuration.version = version
            configuration.buildNumber = version + ".1"
        } else if versionArray.count == 4 {
            configuration.version = versionArray.dropLast().joined(separator: ".")
            configuration.buildNumber = version
        }
    }
}
