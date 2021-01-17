import Foundation

enum SwiftStringFactory {
    static func make(from lines: [[String]]) -> String {
        var output: String = ""

        lines.indices.forEach { index in
            output += lines[index].joined(separator: Tokens.whitespace) + Tokens.newLine
        }

        return output
    }
}
