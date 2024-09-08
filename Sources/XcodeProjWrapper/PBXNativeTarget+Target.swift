internal import XcodeProj

extension PBXNativeTarget: Target {
    public var buildConfigurations: [any BuildConfiguration] {
        buildConfigurationList?.buildConfigurations ?? []
    }
}
