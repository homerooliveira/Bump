import Foundation
import SwiftExtensions
package import XcodeProjWrapper

package struct Bump {
    private var xcodeProj: any XcodeProjWrapperProtocol
    private let bundleIdentifiers: Set<String>
    private let log: (String) -> Void
    private let isVerbose: Bool
    private let useSameVersion: Bool
    private let inPlace: Bool

    package init(
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

    package mutating func bump(flag: IncrementMode) throws {
        let configsByTargetName = getConfigurationsByTargetName()

        if useSameVersion {
            let configs = configsByTargetName
                .values
                .lazy
                .flatMap { $0 }

            guard var config = configs.first else { return }

            let (oldBuildNumber, buildNumber) = applyBumpInFirstConfig(&config, flag: flag)

            if isVerbose {
                let allTargets = configsByTargetName.keys.joined(separator: ", ")
                log(allTargets)
                log("\(oldBuildNumber) -> \(buildNumber)")
            } else {
                log(buildNumber)
            }

            applyBumpToRemainingConfigs(configs.dropFirst(), flag: .versionString(buildNumber))
        } else {
            for (targetName, configs) in configsByTargetName {
                guard var config = configs.first else { continue }

                let (oldBuildNumber, buildNumber) = applyBumpInFirstConfig(&config, flag: flag)

                if isVerbose {
                    let targetOutput = "\(targetName) \(oldBuildNumber) -> \(buildNumber)"
                    log(targetOutput)
                } else {
                    log(buildNumber)
                }

                applyBumpToRemainingConfigs(configs.dropFirst(), flag: flag)
            }
        }

        if inPlace {
            try xcodeProj.saveChanges()
        }
    }

    func applyBumpInFirstConfig(
        _ config: inout BuildConfiguration,
        flag: IncrementMode
    ) -> (oldBuildNumber: String, buildNumber: String) {
        let oldBuildNumber = config.buildNumber ?? ""
        applyBump(configuration: &config, flag: flag)
        let buildNumber = config.buildNumber ?? ""

        return (oldBuildNumber, buildNumber)
    }

    func applyBumpToRemainingConfigs(
        _ configs: some Collection<BuildConfiguration>,
        flag: IncrementMode
    ) {
        for var config in configs {
            applyBump(configuration: &config, flag: flag)
        }
    }

    func getConfigurationsByTargetName() -> [String: [BuildConfiguration]] {
        // Using lazy to avoid creating intermediate arrays.
        xcodeProj
            .targets
            .lazy
            .flatMap { target in
                target
                    .buildConfigurations
                    .lazy
                    .map { ($0, target.name) }
            }
            .filter { (config, _) in
                isValidBundleIdentifier(config.bundleIdentifier)
            }
            .reduce(into: [:]) { configsByTargetName, args in
                let (config, targetName) = args
                configsByTargetName[targetName, default: []].append(config)
            }
    }

    func isValidBundleIdentifier(_ bundleIdentifier: String) -> Bool {
        bundleIdentifiers.contains(where: bundleIdentifier.starts(with:))
            || bundleIdentifiers.contains("all")
    }

    func applyBump(configuration: inout BuildConfiguration, flag: IncrementMode) {
        switch flag {
        case .major:
            bumpVersion(from: &configuration, versionIndex: .major)
        case .minor:
            bumpVersion(from: &configuration, versionIndex: .minor)
        case .patch:
            bumpVersion(from: &configuration, versionIndex: .patch)
        case .build:
            bumpBuildVersion(from: &configuration)
        case .versionString(let version):
            setVersion(version, from: &configuration)
        }
    }

    private func bumpVersion(from configuration: inout BuildConfiguration, versionIndex: VersionIndex) {
        changeVersionsNumbers(from: &configuration) { versionNumbers in
            let currentValue = Int(versionNumbers[versionIndex]) ?? 0
            versionNumbers[versionIndex] = "\(currentValue + 1)"
            if versionIndex != .patch {
                versionNumbers[VersionIndex.patch] = "0"
            }
            if versionIndex == .major {
                versionNumbers[VersionIndex.minor] = "0"
            }
        }
    }

    private func changeVersionsNumbers(
        from configuration: inout BuildConfiguration,
        transform: (inout [Substring]) -> Void
    ) {
        var versionArray: [Substring] = getVersion(configuration.version)
        transform(&versionArray)
        let version = versionArray.joined(separator: ".")
        configuration.version = version
        configuration.buildNumber = "\(version).1"
    }

    private func bumpBuildVersion(from configuration: inout BuildConfiguration) {
        let version = getVersion(configuration.version).joined(separator: ".")
        let buildNumber = getBuildNumber(configuration.buildNumber)
        configuration.version = version
        configuration.buildNumber = "\(version).\(buildNumber)"
    }

    private func getBuildNumber(_ buildNumber: String?) -> String {
        buildNumber?
            .split(separator: ".")
            .last
            .flatMap { Int($0) }
            .map { "\($0 + 1)" } ?? "1"
    }

    private func getVersion(_ version: String?) -> [Substring] {
        guard let version = version?.split(separator: ".") else {
            return ["0", "0", "0"]
        }

        if version.count >= 3 {
            return Array(version.prefix(3))
        }

        return version + Array(repeating: "0", count: 3 - version.count)
    }

    private func setVersion(_ version: String, from configuration: inout BuildConfiguration) {
        let versionArray = version.split(separator: ".")

        if versionArray.count == 3 {
            let version = versionArray.joined(separator: ".")
            configuration.version = version
            configuration.buildNumber = "\(version).1"
        } else if versionArray.count == 4 {
            configuration.version = versionArray.dropLast().joined(separator: ".")
            configuration.buildNumber = version
        }
    }
}
