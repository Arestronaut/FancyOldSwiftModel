import Foundation

enum Console {
    enum MessageType {
        case status
        case error

        var prefix: String {
            switch self {
            case .status: return "🐌"
            case .error: return "💔"
            }
        }
    }

    static func print(_ messageType: MessageType = .status, _ message: String, _ arguments: CVarArg...) {
        let message = String(format: message, arguments: arguments)

        Swift.print(String(format: "%@: %@", messageType.prefix, message))
    }
}
