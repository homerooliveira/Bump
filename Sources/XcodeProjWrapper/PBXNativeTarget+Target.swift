internal import XcodeProj

extension PBXNativeTarget: Target {
    var buildConfigurations: [any BuildConfiguration] {
        buildConfigurationList?.buildConfigurations ?? []
    }
}
