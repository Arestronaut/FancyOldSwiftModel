import Foundation

struct GenerateModelArgument {
    var identifier: String
    var model: InlineModel
    var output: String?

    var outputURL: URL {
        switch output {
        case let .some(path):
            return FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(path)

        case .none:
            return FileManager.default.currentDirectoryPath.url
        }
    }
}
