import Foundation

enum SwiftModelFactory {
    static func map(from generateModelArgument: GenerateModelArgument) -> SwiftModel {
        let parts = generateModelArgument.model.parts
        // TODO: The properties are set to settable by default. This should be configurable
        let properties: Properties = parts.map { Property(identifier: $0.identifier, type: $0.type, isSettable: true) }

        return SwiftModel(
            identifier: generateModelArgument.identifier,
            conformance: "",
            properties: properties,
            imports: [.foundation]
        )
    }
}
