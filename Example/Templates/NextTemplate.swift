import Foundation
import Combine

// modelgenconfig: refType, open
protocol AccountTemplate: Equatable, Codable {
    var id: UUID { get }
    var name: String { get set }
}
