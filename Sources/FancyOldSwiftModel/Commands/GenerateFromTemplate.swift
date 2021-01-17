import ArgumentParser
import Foundation

struct GenerateFromTemplate: ParsableCommand {
    public static let configuration: CommandConfiguration = .init(
        commandName: "generateFromTemplate",
        abstract: "Generates swift model from the provided templates."
    )

    @Option(name: .shortAndLong)
    var modelPath: String

    @Option(name: .shortAndLong)
    var templatePath: String

    @Flag(help: "Creates the given directories if they don't already exist")
    var creates: Bool = false

    func run() throws {
        let modelURL = URL(fileURLWithPath: FileManager.default.homeDirectoryForCurrentUser.path.appending(modelPath), isDirectory: true)
        let templatesURL = URL(fileURLWithPath: FileManager.default.homeDirectoryForCurrentUser.path.appending(templatePath), isDirectory: true)

        GenerationPipelineManager.global.queue(generateFromTemplateArgument: .init(modelPath: modelURL.path, templatePath: templatesURL.path, creates: creates))
    }
}
