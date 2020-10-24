import Foundation
import Environment

var Current = Environment()

public enum BumpMain {
    public static func main() {
        BumpCommand.main()
    }
}
