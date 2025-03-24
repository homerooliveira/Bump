import XcodeProj

package struct Target {
    package let name: String
    package var buildConfigurations: [BuildConfiguration] = []

    package init(name: String, buildConfigurations: [BuildConfiguration]) {
        self.name = name
        self.buildConfigurations = buildConfigurations
    }

    init(target: PBXNativeTarget) {
        self.name = target.name
        self.buildConfigurations =
            target.buildConfigurationList?
            .buildConfigurations
            .map { BuildConfiguration(buildConfiguration: $0) } ?? []
    }
}
