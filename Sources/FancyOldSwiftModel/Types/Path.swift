import Foundation

typealias Path = String

extension Path {
    var exists: Bool {
        FileManager.default.fileExists(atPath: self)
    }

    var url: URL {
        URL(fileURLWithPath: self, isDirectory: true)
    }
}
