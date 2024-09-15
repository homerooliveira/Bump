internal import XcodeProj

struct TargetWrapper: Target {
    let target: PBXNativeTarget

    var name: String {
        target.name
    }

    var buildConfigurations: [any BuildConfiguration] {
        (target.buildConfigurationList?.buildConfigurations ?? []).map { buildConfiguration in
            BuildConfigurationWrapper(buildConfiguration: buildConfiguration)
        }
    }
}
