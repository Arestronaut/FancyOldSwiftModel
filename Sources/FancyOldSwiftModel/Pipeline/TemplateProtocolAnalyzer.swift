import AST
import Foundation

final class TemplateProtocolAnalyzer: ChainedAsyncResultOperation<(TopLevelDeclaration, Statements), SwiftModel, TemplateProtocolAnalyzer.Error> {
    enum Error: Swift.Error {
        case missingInput
    }

    override func main() {
        guard let (topLevelDeclarations, imports) = input else { return finish(with: .failure(.missingInput))}

        let protocolVisitor = ProtocolVisitor.init(comments: topLevelDeclarations.comments, imports: imports)
        protocolVisitor.protocolVisitedHandler = { [weak self] swiftModel in
            guard let self = self else { return }
            return self.finish(with: .success(swiftModel))
        }

        _ = try? protocolVisitor.traverse(topLevelDeclarations)
    }
}
