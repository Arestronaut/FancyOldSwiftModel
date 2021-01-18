import Foundation

typealias InlineModel = String
typealias InlineModelPart = (identifier: String, type: String)
typealias InlineModelParts = [InlineModelPart]

extension InlineModel {
    var isValid: Bool { self ~= Expressions.inlineModel }

    var parts: InlineModelParts {
        self
            .split(separator: ",")
            .map { parts in
                let inlineModelParts = parts
                    .split(separator: ":")
                    .map({ subparts in subparts.trimmingCharacters(in: .whitespacesAndNewlines) })

                return (identifier: inlineModelParts[0], type: inlineModelParts[1])
            }
    }
}
