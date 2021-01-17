import Foundation

enum Tokens {
    static let `struct`: String = "struct"
    static let `class`: String = "class"
    static let `var`: String = "var"
    static let `let`: String = "let"
    static let openCurlyBracket: String = "{"
    static let closedCurlyBracket: String = "}"
    static let whitespace: String = " "
    static let newLine: String = "\n"
    static let tab: String = "\t"
    static let empty: String = ""
    static let colon: String = ":"
    static let comma: String = ","
    static let `init`: String = "init"
    static let openBracket: String = "("
    static let closedBracket: String = ")"
    static let `default`: String = "default"
    static let `self`: String = "self"
    static let `Self`: String = "Self"
    static let equals: String = "="
    static let dot: String = "."
    static let `extension`: String = "extension"
    static let `static`: String = "static"
    static let backTick: String = "`"
    static let `import`: String = "import"
    static let `final`: String = "final"
    static let `func`: String = "func"
    static let minus: String = "-"
    static let greaterThan: String = ">"
    static let and: String = "&"
    static let open: String = "open"
    static let `public`: String = "public"
    static let swiftFileExtensions: String = ".swift"
    static let `case`: String = "case"

    enum Signatures {
        static let hasher: String = "func hash(into hasher: inout Hasher)"

        static func equatable(identifier: String) -> String {
            "static func ==(lhs: \(identifier), rhs: \(identifier)) -> Bool"
        }

        static let codingKeys: String = "enum CodingKeys: String, CodingKey"
        static let decoderInit: String = "required init(from decoder: Decoder) throws"
        static let encoder: String = "func encode(to encoder: Encoder) throws"
    }

    enum Expression {
        static func equatable(property: String) -> String {
            "lhs.\(property) == rhs.\(property)"
        }

        static func hasher(property: String) -> String {
            "hasher.combine(\(property))"
        }

        static let decoderContainer: String = "let container = try decoder.container(keyedBy: CodingKeys.self)"

        static func decodeProperty(identifier: String, type: String) -> String {
            "self.\(identifier) = try container.decode(\(type).self, forKey: .\(identifier))"
        }

        static let encoderContainer: String = "var container = encoder.container(keyedBy: CodingKeys.self)"

        static func encodeProperty(identifier: String) -> String {
            "try container.encode(self.\(identifier), forKey: .\(identifier))"
        }

        static func mark(description: String) -> String {
            "// MARK: - Equatable"
        }
    }

    enum Protocols {
        static let hashable: String = "Hashable"
        static let equatable: String = "Equatable"
        static let codable: String = "Codable"
        static let decodable: String = "Decodable"
        static let encodable: String = "Encodable"
    }
}
