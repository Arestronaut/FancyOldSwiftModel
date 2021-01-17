import Foundation

// modelgenconfig: refType, open
protocol AccountTemplate: Equatable, Codable {
    var id: UUID { get }
    var name: String { get set }
}
