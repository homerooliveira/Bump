import XcodeProjWrapper

public struct TargetMock: Target {
    public let name: String
    public let buildConfigurations: [any BuildConfiguration]

    public init(name: String, buildConfigurations: [any BuildConfiguration]) {
        self.name = name
        self.buildConfigurations = buildConfigurations
    }
}
