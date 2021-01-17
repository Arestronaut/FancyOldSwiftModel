import Foundation

enum InputFileExtractor {
    static func extractInputFiles(from argument: GenerateFromTemplateArgument) -> [URL] {
        guard argument.modelPath.exists else {
            guard argument.creates else { return [] } // TODO: Print error

            try? FileManager.default.createDirectory(at: argument.modelPath.url, withIntermediateDirectories: true, attributes: nil)
            return []
        }

        guard argument.templatePath.exists else {
            guard argument.creates else { return [] }

            try? FileManager.default.createDirectory(at: argument.templatePath.url, withIntermediateDirectories: true, attributes: nil)
            return []
        }

        do {
            let templates = try FileManager.default
                .contentsOfDirectory(atPath: argument.templatePath)
                .compactMap({ argument.templatePath.url.appendingPathComponent("\($0)") })
                .filter({ $0.lastPathComponent ~= Expressions.templateFile })

            return templates
        } catch {
            return []
        }
    }
}
