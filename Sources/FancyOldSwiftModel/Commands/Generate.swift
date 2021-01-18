import ArgumentParser
import Combine
import Foundation

struct Generate: ParsableCommand {
    public static let configuration: CommandConfiguration = .init(
        commandName: "generate",
        abstract: "Generates swift model from the provided templates."
    )

    @Option(name: .shortAndLong)
    private var identifier: String

    @Option(name: .shortAndLong)
    private var model: String

    @Option(name: .shortAndLong)
    private var output: String?

    func run() throws {
        GenerationPipelineManager.global.queue(
            generateModelArgument: .init(identifier: identifier, model: model, output: output)
        )
    }
}
