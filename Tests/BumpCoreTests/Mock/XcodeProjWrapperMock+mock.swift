import XcodeProjWrapper
import XcodeProjWrapperMock

extension XcodeProjWrapperMock {
    static var mock: XcodeProjWrapperMock {
        XcodeProjWrapperMock(
            targets: [
                Target(
                    name: "Test1",
                    buildConfigurations: [
                        BuildConfiguration(
                            bundleIdentifier: "test",
                            buildNumber: "1",
                            version: "1.0"
                        )
                    ]
                ),
                Target(
                    name: "Test2",
                    buildConfigurations: [
                        BuildConfiguration(
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
                Target(
                    name: "Test1",
                    buildConfigurations: [
                        BuildConfiguration(
                            bundleIdentifier: "test",
                            buildNumber: "1",
                            version: "1.0"
                        )
                    ]
                ),
                Target(
                    name: "Test2",
                    buildConfigurations: [
                        BuildConfiguration(
                            bundleIdentifier: "com.test",
                            buildNumber: "1",
                            version: "1.0"
                        )
                    ]
                ),
                Target(
                    name: "Test3",
                    buildConfigurations: [
                        BuildConfiguration(
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
