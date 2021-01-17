import AST
import Foundation
import Parser
import Source

/// Reads and parses swift source file
final class SourceFileReader: ChainedAsyncResultOperation<URL, TopLevelDeclaration, SourceFileReader.Error> {
    enum Error: Swift.Error {
        case missingInput
        case parsingSourceFile
    }

    override func main() {
        guard let input = input else { return finish(with: .failure(.missingInput)) }

        do {
            let sourceFile = try SourceReader.read(at: input.path)
            let parser = Parser(source: sourceFile)
            let toplevelDeclaration = try parser.parse()

            return finish(with: .success(toplevelDeclaration))
        } catch {
            return finish(with: .failure(.parsingSourceFile))
        }
    }
}
