import AST
import Foundation

final class ImportExtractor: ChainedAsyncResultOperation<TopLevelDeclaration, (TopLevelDeclaration, Statements), ImportExtractor.Error> {
    enum Error: Swift.Error {
        case missingInput
    }

    override func main() {
        guard let input = self.input else { return finish(with: .failure(.missingInput)) }

        let imports = input.statements.filter { $0.textDescription ~= Expressions.import }
        return finish(with: .success((input, imports)))
    }
}
