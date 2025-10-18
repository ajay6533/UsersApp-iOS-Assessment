
import Foundation


struct User: Codable, Identifiable, Equatable {
    let id: Int
    let name: String?
    let username: String?
    let email: String?
    let phone: String?
    let photo: String?
}
