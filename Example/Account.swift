import Foundation
import Combine

open class Account: Codable, Equatable {
	public let id: UUID
	open var name: String

	public init(id: UUID, name: String) {
		self.id = id
		self.name = name
	}
}

// MARK: - Equatable
extension Account {
	public static func ==(lhs: Account, rhs: Account) -> Bool {
		lhs.id == rhs.id && lhs.name == rhs.name
	 }
}
