import XcodeProj

public struct Target {
    public let name: String
    public var buildConfigurations: [BuildConfiguration] = []

    public init(name: String, buildConfigurations: [BuildConfiguration]) {
        self.name = name
        self.buildConfigurations = buildConfigurations
    }

    init(target: PBXNativeTarget) {
        self.name = target.name
        self.buildConfigurations = target.buildConfigurationList?
            .buildConfigurations
            .map { BuildConfiguration(buildConfiguration: $0) } ?? []
    }
}
