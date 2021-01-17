import Foundation

final class GenerationPipelineManager {
    static let global: GenerationPipelineManager = .init()

    func queue(generateFromTemplateArgument: GenerateFromTemplateArgument) {
        let templateURLs: [URL] = InputFileExtractor.extractInputFiles(from: generateFromTemplateArgument)

        for templateURL in templateURLs {
            GenerationPipeline().run(with: templateURL, output: generateFromTemplateArgument.modelPath.url)
        }
    }

    func queue(generateModelArgument: GenerateModelArgument) {

    }
}
