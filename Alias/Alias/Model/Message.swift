

import Foundation

struct Message: Identifiable {
    let id: UUID = UUID()
    let text: String
    let createdAt: Int
    let creator: User
    
    
    init(text: String, createdAt: Int, creator: User) {
        self.text = text
        self.createdAt = createdAt
        self.creator = creator
    }
}

struct FakeMsg: Codable {
    let text: String
    let createdAt: Int
    let creator: User
}
