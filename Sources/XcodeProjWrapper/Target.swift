internal import XcodeProj

public struct Target {
    public let name: String
    public var buildConfigurations: [any BuildConfiguration] = []

    public init(name: String, buildConfigurations: [any BuildConfiguration]) {
        self.name = name
        self.buildConfigurations = buildConfigurations
    }

    init(target: PBXNativeTarget) {
        self.name = target.name
        self.buildConfigurations = target.buildConfigurationList?
            .buildConfigurations
            .map { BuildConfigurationWrapper(buildConfiguration: $0) } ?? []
    }
}
