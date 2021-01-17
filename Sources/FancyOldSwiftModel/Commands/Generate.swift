import ArgumentParser
import Combine
import Foundation

struct Generate: ParsableCommand {
    public static let configuration: CommandConfiguration = .init(
        commandName: "generate",
        abstract: "Generates swift model from the provided templates."
    )

    @Option(name: .shortAndLong)
    private var model: String

    func run() throws {
        GenerationPipelineManager.global.queue(generateModelArgument: .init(model: model))
    }
}
