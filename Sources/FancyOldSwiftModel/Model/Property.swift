import Foundation

struct Property {
    let identifier: String
    let type: String
    let isSettable: Bool

    var swiftString: String {
        let declarationKeyword: String = isSettable ? Tokens.var : Tokens.let
        return declarationKeyword + Tokens.whitespace + identifier + Tokens.colon + Tokens.whitespace + type
    }

    init(identifier: String, type: String, isSettable: Bool) {
        self.identifier = identifier
        self.type = type
        self.isSettable = isSettable
    }
}

typealias Properties = [Property]
