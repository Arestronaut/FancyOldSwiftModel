import Foundation

final class SwiftModel {
    let identifier: String
    // TODO: For the sake of consistency conformances should be a typealias for string.
    //       This property contains the raw conformance statement as represented in the AST and is split by the property conformances
    //       That should be done beforehand
    private let conformance: String
    private let properties: Properties

    var configProperties: ConfigOptions? {
        didSet {
            if !conformances.contains(Tokens.Protocols.codable) {
                switch (hasExplicitEncoder, hasExplicitDecoder) {
                case (true, true): conformances.insert(Tokens.Protocols.codable)
                case (false, true): guard conformances.contains(Tokens.Protocols.decodable) else { conformances.insert(Tokens.Protocols.decodable); return }
                case (true, false): guard conformances.contains(Tokens.Protocols.encodable) else { conformances.insert(Tokens.Protocols.encodable); return }
                default: return
                }
            }
        }
    }

    private var imports: Imports

    private lazy var isRefType: Bool = {
        configProperties?.contains(.refType) == true
    }()

    private lazy var hasDefaultInit: Bool = {
        configProperties?.contains(.defaultInit) == true
    }()

    private lazy var isFinal: Bool = {
        configProperties?.contains(.subclassable) == true
    }()

    private lazy var isOpen: Bool = {
        configProperties?.contains(.open) == true
    }()

    private lazy var isPublic: Bool = {
        configProperties?.contains(.public) == true
    }()

    private lazy var hasExplicitDecoder: Bool = {
        configProperties?.contains(.explicitDecodable) == true
    }()

    private lazy var hasExplicitEncoder: Bool = {
        configProperties?.contains(.explicitEncodable) == true
    }()

    private lazy var conformances: Set<String> = {
        .init(conformance.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) })
    }()

    var swiftString: String {
        var parts: [[String]] = []

        // imports
        // TODO: The imports are currently represented as a String containing the full statement(e.g. import Foundation)
        //       An import should be simply the module name that is imported and the import Token should be added in this step.
        imports.forEach { `import` in
            parts.append([`import`])
        }

        parts.append([])

        // Object Header
        var objectHeader: [String] = self.isRefType ?
            (self.isFinal ? [Tokens.final, Tokens.class] : [Tokens.class]) :
            [Tokens.struct]

        if !conformances.isEmpty {
            objectHeader.append(identifier + Tokens.colon)
            objectHeader.append(conformances.joined(separator: Tokens.comma + Tokens.whitespace))
        } else {
            objectHeader.append(identifier)
        }

        objectHeader.append(Tokens.openCurlyBracket)

        if let accessModifier = isOpen ? (isFinal ? Tokens.public : Tokens.open) : (isPublic ? Tokens.public : nil) {
            parts.append([accessModifier] + objectHeader)
        } else {
            parts.append(objectHeader)
        }

        if hasExplicitEncoder || hasExplicitDecoder {
            codingKeysEnum(parts: &parts)
        }

        // Properties
        properties.forEach {
            parts.append(
                [
                    Tokens.tab +
                        (
                            isOpen ?
                                ($0.isSettable ? Tokens.open + Tokens.whitespace : Tokens.public + Tokens.whitespace) :
                                (isPublic ? Tokens.public + Tokens.whitespace : Tokens.empty)
                        ) +
                        $0.swiftString
                ]
            )
        }

        // Default init
        if hasDefaultInit {
            initializer(properties: properties, parts: &parts, isDefaulInit: true)
        } else if isRefType {
            initializer(properties: properties, parts: &parts, isDefaulInit: false)
        }

        if hasExplicitDecoder {
            // Newline
            parts.append([])

            // Init(from decoder)
            decoderInit(parts: &parts)
        }

        // Closing Bracket
        parts.append([Tokens.closedCurlyBracket])

        if hasDefaultInit {
            defaultInit(properties: properties, parts: &parts)
        }

        if hasExplicitEncoder {
            // New line
            parts.append([])

            encoderExtension(parts: &parts)
        }

        if isRefType, (conformances.contains(Tokens.Protocols.hashable) || conformances.contains(Tokens.Protocols.equatable)) {
            // New line
            parts.append([])

            equatable(parts: &parts)

            if conformances.contains(Tokens.Protocols.hashable) {
                // New Line
                parts.append([])

                hashable(parts: &parts)
            }
        }

        return SwiftStringFactory.make(
            from: parts
        )
    }

    init(identifier: String, conformance: String, properties: Properties, imports: Imports) {
        self.identifier = identifier
        self.conformance = conformance
        self.properties = properties
        self.imports = imports
    }

    private func initializer(properties: Properties, parts: inout [[String]], isDefaulInit: Bool = false) {
        // NewLine
        parts.append([])

        // init(
        var initializer: String = Tokens.tab + ((isOpen || isPublic) ? (Tokens.public + Tokens.whitespace) : Tokens.empty) + Tokens.`init` + Tokens.openBracket

        // E.g. propertyName: Type = Self.default.propertyName
        let objectReference: String = self.isRefType ? identifier : Tokens.`Self`

        let initFields = properties
            .map { property -> String in
                var propertySignature: [String] = []

                if isDefaulInit {
                    propertySignature = [
                        property.identifier + Tokens.colon,
                        property.type,
                        Tokens.equals,
                        objectReference + Tokens.dot + Tokens.default + Tokens.dot + property.identifier
                    ]
                } else {
                    propertySignature = [
                        property.identifier + Tokens.colon,
                        property.type,
                    ]
                }

                return propertySignature.joined(separator: Tokens.whitespace)
            }
            .joined(separator: Tokens.comma + Tokens.whitespace)
        initializer.append(initFields)

        // )
        initializer.append(Tokens.closedBracket)

        // {
        parts.append([initializer, Tokens.openCurlyBracket])

        // self.property = property
        properties.forEach {
            parts.append([Tokens.tab + Tokens.tab + Tokens.`self` + Tokens.dot + $0.identifier, Tokens.equals, $0.identifier])
        }

        // }
        parts.append([Tokens.tab + Tokens.closedCurlyBracket])
    }

    private func defaultInit(properties: Properties, parts: inout [[String]]) {
        // NewLine
        parts.append([])

        // extension Identifier {
        parts.append([Tokens.extension, identifier, Tokens.openCurlyBracket])

        // static let `default`: Self = .init(
        parts.append(
            [
                Tokens.tab + ((isOpen || isPublic) ? (Tokens.public + Tokens.whitespace) : Tokens.empty) + Tokens.static,
                Tokens.let,
                Tokens.backTick + Tokens.default + Tokens.backTick + Tokens.colon,
                self.isRefType ? identifier : Tokens.`Self`,
                Tokens.equals,
                Tokens.dot + Tokens.`init` + Tokens.openBracket
            ]
        )

        let propertyInitializer = properties
            .map { property -> String in
                Tokens.tab + Tokens.tab + property.identifier + Tokens.colon + Tokens.whitespace + Tokens.dot + Tokens.`init` + Tokens.openBracket + Tokens.closedBracket
            }
            .joined(separator: Tokens.comma + Tokens.newLine)

        parts.append([propertyInitializer])
        parts.append([Tokens.tab + Tokens.closedBracket])

        parts.append([Tokens.closedCurlyBracket])
    }

    private func equatable(parts: inout [[String]]) {
        parts.append([Tokens.Expression.mark(description: Tokens.Protocols.equatable)])

        // extension Identifier {
        parts.append([Tokens.extension, identifier, Tokens.openCurlyBracket])

        // -> static func ==(lhs: identifier, rhs: identifier) -> Bool
        parts.append(
            [
                Tokens.tab + ((isOpen || isPublic) ? (Tokens.public + Tokens.whitespace) : Tokens.empty) + Tokens.Signatures.equatable(identifier: identifier),
                Tokens.openCurlyBracket
            ]
        )

        // [lhs.propertyA == rhs.propertyA, lhs.propertyB == rhs.propertyB, ...]
        let propertyComparisons: [String] = properties.map { property -> String in
            Tokens.Expression.equatable(property: property.identifier)
        }

        // lhs.propertyA == rhs.propertyA &&\nlhs.propertyB == rhs.propertyB &&\n...
        let propertyComparison: String = propertyComparisons.joined(separator: Tokens.whitespace + Tokens.and + Tokens.and + Tokens.whitespace)

        // ->-> Comparisons
        parts.append([Tokens.tab + Tokens.tab + propertyComparison])

        // -> }
        parts.append([Tokens.tab, Tokens.closedCurlyBracket])

        // }
        parts.append([Tokens.closedCurlyBracket])
    }

    private func hashable(parts: inout [[String]]) {
        parts.append([Tokens.Expression.mark(description: Tokens.Protocols.hashable)])

        // extension Identifier {
        parts.append([Tokens.extension, identifier, Tokens.openCurlyBracket])

        // -> func hash(into hasher: inout Hasher) {
        parts.append(
            [
                Tokens.tab + ((isOpen || isPublic) ? (Tokens.public + Tokens.whitespace) : Tokens.empty) + Tokens.Signatures.hasher,
                Tokens.openCurlyBracket
            ]
        )

        // ->-> hasher.combine(property)
        properties.forEach { property in
            parts.append(
                [
                    Tokens.tab + Tokens.tab + Tokens.Expression.hasher(property: property.identifier)
                ]
            )
        }

        // -> }
        parts.append(
            [
                Tokens.tab + Tokens.closedCurlyBracket
            ]
        )

        // }
        parts.append([Tokens.closedCurlyBracket])
    }

    private func codingKeysEnum(parts: inout [[String]]) {
        // -> enum CodingKeys: String, CodingKey {
        parts.append([Tokens.tab + Tokens.Signatures.codingKeys, Tokens.openCurlyBracket])

        properties.forEach { property in
            parts.append(
                [
                    Tokens.tab + Tokens.tab + Tokens.case,
                    property.identifier
                ]
            )
        }

        // -> }
        parts.append([Tokens.tab + Tokens.closedCurlyBracket])

        // New Line
        parts.append([])
    }

    private func decoderInit(parts: inout [[String]]) {
        // -> required init(from decoder: Decoder) throws {
        parts.append(
            [
                Tokens.tab + ((isOpen || isPublic) ? (Tokens.public + Tokens.whitespace) : Tokens.empty) + Tokens.Signatures.decoderInit,
                Tokens.openCurlyBracket
            ]
        )

        // ->->let container = try decoder.container(keyedBy: CodingKeys.self)
        parts.append(
            [
                Tokens.tab + Tokens.tab + Tokens.Expression.decoderContainer
            ]
        )

        // Newline
        parts.append([])

        // ->->self.property = try container.decode(Type.self, forKey: .propertyName)
        properties.forEach { property in
            parts.append(
                [
                    Tokens.tab + Tokens.tab + Tokens.Expression.decodeProperty(identifier: property.identifier, type: property.type)
                ]
            )
        }

        // -> }
        parts.append(
            [
                Tokens.tab + Tokens.closedCurlyBracket
            ]
        )
    }

    private func encoderExtension(parts: inout [[String]]) {
        parts.append([Tokens.Expression.mark(description: Tokens.Protocols.encodable)])

        // extension Identifier {
        parts.append([Tokens.extension, identifier, Tokens.openCurlyBracket])

        // -> func encode(to encoder: Encoder) throws {
        parts.append(
            [
                Tokens.tab + ((isOpen || isPublic) ? (Tokens.public + Tokens.whitespace) : Tokens.empty) + Tokens.Signatures.encoder,
                Tokens.openCurlyBracket
            ]
        )

        // ->->var container = encoder.container(keyedBy: CodingKeys.self)
        parts.append([Tokens.tab + Tokens.tab + Tokens.Expression.encoderContainer])

        // Newline
        parts.append([])

        // ->->try container.encode(self.property, forKey: .propertyName)
        properties.forEach { property in
            parts.append(
                [
                    Tokens.tab + Tokens.tab + Tokens.Expression.encodeProperty(identifier: property.identifier)
                ]
            )
        }

        // -> }
        parts.append(
            [
                Tokens.tab + Tokens.closedCurlyBracket
            ]
        )

        // }
        parts.append([Tokens.closedCurlyBracket])
    }
}
