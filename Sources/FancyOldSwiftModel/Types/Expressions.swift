enum Expressions {
    static var templateFile: String = "^\\w+Template.swift$"
    static let modelIdentifier: String = ".+?(?=Template)"
    static let config: String = "^modelgenconfig:"
    static let configProperties: String = "(?<=modelgenconfig:).*"
    static let `import`: String = "^import [^\\s]+$"
    static let imports: String = "(?<=import )[^\\s]+"
    static let inlineModel: String = "[a-zA-Z0-9]+:\\s?[a-zA-Z0-9]+(\\,\\s?[a-zA-Z0-9]+:\\s?[a-zA-Z0-9]+)+"
}
