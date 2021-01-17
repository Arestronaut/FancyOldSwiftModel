import import Foundation

class Next: Equatable {
	var name: String

	init(name: String) {
		self.name = name
	}
}

// MARK: - Equatable
extension Next {
	static func ==(lhs: Next, rhs: Next) -> Bool {
		lhs.name == rhs.name
	 }
}
