import Foundation

enum Config: String {
    case defaultInit = "default_init"
    case refType = "refType"
    case subclassable = "subclassable"
    case open = "open"
    case `public` = "public"
    case explicitDecodable = "explicit_decodable"
    case explicitEncodable = "explicit_encodable"
}

struct ConfigOptions: OptionSet {
    let rawValue: Int

    static let defaultInit = Self(rawValue: 1 << 0)
    static let refType = Self(rawValue: 1 << 1)
    static let subclassable = Self(rawValue: 1 << 2)
    static let open = Self(rawValue: 1 << 3)
    static let `public` = Self(rawValue: 1 << 4)
    static let explicitDecodable = Self(rawValue: 1 << 5)
    static let explicitEncodable = Self(rawValue: 1 << 6)

    static func map(config: Config) -> Self {
        switch config {
        case .defaultInit: return .defaultInit
        case .refType: return .refType
        case .subclassable: return .subclassable
        case .open: return .open
        case .public: return .public
        case .explicitDecodable: return .explicitDecodable
        case .explicitEncodable: return .explicitEncodable
        }
    }
}
