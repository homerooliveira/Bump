import XcodeProjWrapperMock

extension XcodeProjWrapperMock {
    static var mock: XcodeProjWrapperMock {
        XcodeProjWrapperMock(
            targets: [
                TargetMock(
                    name: "Test1",
                    buildConfigurations: [
                        BuildConfigurationMock(
                            bundleIdentifier: "test",
                            buildNumber: "1",
                            version: "1.0"
                        )
                    ]
                ),
                TargetMock(
                    name: "Test2",
                    buildConfigurations: [
                        BuildConfigurationMock(
                            bundleIdentifier: "com.test",
                            buildNumber: "1",
                            version: "1.0"
                        )
                    ]
                )
            ]
        )
    }

    static var mockWithThreeConfigs: XcodeProjWrapperMock {
        XcodeProjWrapperMock(
            targets: [
                TargetMock(
                    name: "Test1",
                    buildConfigurations: [
                        BuildConfigurationMock(
                            bundleIdentifier: "test",
                            buildNumber: "1",
                            version: "1.0"
                        )
                    ]
                ),
                TargetMock(
                    name: "Test2",
                    buildConfigurations: [
                        BuildConfigurationMock(
                            bundleIdentifier: "com.test",
                            buildNumber: "1",
                            version: "1.0"
                        )
                    ]
                ),
                TargetMock(
                    name: "Test3",
                    buildConfigurations: [
                        BuildConfigurationMock(
                            bundleIdentifier: "com.test",
                            buildNumber: "1",
                            version: "1.0"
                        )
                    ]
                )
            ]
        )
    }
}
