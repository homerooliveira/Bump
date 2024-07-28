import Environment
import Foundation

var Current = Environment()

public enum BumpMain {
    public static func main() {
        BumpCommand.main()
    }
}
