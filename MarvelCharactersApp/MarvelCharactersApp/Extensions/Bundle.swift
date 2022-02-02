import Foundation

extension Bundle {
    static var defaultConfig: NSDictionary {
        NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)!
    }
}
