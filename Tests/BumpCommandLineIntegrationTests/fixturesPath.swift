import Foundation

func fixturesPath() -> URL {
    Bundle.module.resourceURL ?? URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .appendingPathComponent("Resources")
}
