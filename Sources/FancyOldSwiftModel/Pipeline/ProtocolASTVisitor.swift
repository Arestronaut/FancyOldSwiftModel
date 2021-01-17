import AST
import Foundation
import Parser
import Source

final class ProtocolVisitor: ASTVisitor {
    typealias SwiftModelCallback = (SwiftModel) throws -> Void

    var protocolVisitedHandler: SwiftModelCallback?

    private var comments: CommentSet
    private var imports: Imports

    init(comments: CommentSet, imports: Statements) {
        self.comments = comments

        self.imports = imports
            .compactMap { `import` in
                let rawImport = `import`.textDescription
                return rawImport ~= Expressions.imports ? rawImport : nil
            }
    }

    func visit(_ protocolDeclaration: ProtocolDeclaration) throws -> Bool {
        // This method is called everytime a protocol declaration is found in the AST of the given file
        // In the following steps the protocol members are mapped to internal types
        let properties: [Property] = protocolDeclaration.members.compactMap { member -> Property? in
            guard case let .property(propertyMember) = member else { return nil }

            return Property(
                identifier: propertyMember.name.textDescription,
                type: propertyMember.typeAnnotation.type.textDescription,
                isSettable: propertyMember.getterSetterKeywordBlock.setter != nil
            )
        }

        let protocolName = protocolDeclaration.name.textDescription
        let identifier = matches(for: Expressions.modelIdentifier, in: protocolName).first ?? protocolName
        let conformance = (protocolDeclaration.typeInheritanceClause?.typeInheritanceList ?? []).map { $0.textDescription }.joined(separator: Tokens.comma + Tokens.whitespace)

        let swiftModel = SwiftModel(identifier: identifier, conformance: conformance, properties: properties, imports: self.imports)

        // Grap the first comment that is in the line before the protocol declaration
        if let configComment = comments.first(where: { $0.location.line == protocolDeclaration.sourceLocation.line - 1 }) {
            // Since the comment provided by the framework has a leading whitespace it needs to be trimmed of
            let trimmedComment = configComment.content.trimmingCharacters(in: .whitespacesAndNewlines)

            // Check if the comment matches the needed structure
            // And extract the separate configurations
            guard
                trimmedComment ~= Expressions.config,
                let match = NSRegularExpression(Expressions.configProperties)
                    .matches(in: trimmedComment, range: .init(trimmedComment.startIndex..., in: trimmedComment))
                    .map({ String(trimmedComment[Range($0.range, in: trimmedComment)!]) })
                    .first
            else { return true }

            // From the previous step the configurations are provided as a single string. To break it off in single configurations the string is split using ','
            // as a separator and trimmed by and leading and/or trailing whitespaces
            var configProperties = match
                .split(separator: Character(Tokens.comma))
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .compactMap { Config(rawValue: $0) }
                .reduce(ConfigOptions()) { $0.union(.map(config: $1)) }

            if configProperties.contains(.open) && configProperties.contains(.public) {
                configProperties.remove(.public)
            }

            swiftModel.configProperties = configProperties
        }

        try protocolVisitedHandler?(swiftModel)

        return true
    }

    private func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
