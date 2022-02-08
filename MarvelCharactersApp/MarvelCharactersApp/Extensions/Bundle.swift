import Foundation

extension Bundle {
    static var defaultConfig: NSDictionary {
        NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)!
    }

    static func loadFile(name: String, type: String) throws -> Data {
        guard let filePath = Bundle.main.path(forResource: name, ofType: type),
              let fileUrl = URL(string: filePath) else {
            throw FileError.fileNotFound
        }

        return try Data(contentsOf: fileUrl)
    }
}
