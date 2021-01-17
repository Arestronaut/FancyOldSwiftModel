import Foundation

final class GenerationPipeline {
    func run(with input: URL, output outputURL: URL) {
        Console.print(.status, "Starting generation pipeline for: %@", input.lastPathComponent)

        // The pipeline is built on top of `OperationQueue`. Every step itself is an async Operation. The steps are put in sync with dependencies
        let sourceFileReader = SourceFileReader(input: input)
        let importsExtractor = ImportExtractor()
        let templateProtocolAnalyzer = TemplateProtocolAnalyzer()
        let sourceFileWriter = SourceFileWriter(modelsURL: outputURL)

        importsExtractor.addDependency(sourceFileReader)
        templateProtocolAnalyzer.addDependency(importsExtractor)
        sourceFileWriter.addDependency(templateProtocolAnalyzer)

        // For the individual steps just print out if something went wrong.
        sourceFileReader.onResult = { result in
            guard case let .failure(error) = result else { return }
            Console.print(.error, "Reading source file: &@", error.localizedDescription)
        }

        importsExtractor.onResult = { result in
            guard case let .failure(error) = result else { return }
            Console.print(.error, "Reading source file: &@", error.localizedDescription)
        }

        templateProtocolAnalyzer.onResult = { result in
            guard case let .failure(error) = result else { return }
            Console.print(.error, "Reading source file: &@", error.localizedDescription)
        }

        sourceFileWriter.onResult = { _ in
            Console.print(.status, "Successfully generated model")
        }

        let queue = OperationQueue()
        queue.addOperations(
            [
                sourceFileReader,
                importsExtractor,
                templateProtocolAnalyzer,
                sourceFileWriter
            ],
            waitUntilFinished: true
        )
    }
}
