import Foundation
import SwiftUI

// MARK: - Profile Model
struct Profile: Identifiable {
    let id: UUID
    let name: String
    let avatarColor: Color
    let isKidsProfile: Bool
    let isLocked: Bool

    init(
        id: UUID = UUID(),
        name: String,
        avatarColor: Color,
        isKidsProfile: Bool = false,
        isLocked: Bool = false
    ) {
        self.id = id
        self.name = name
        self.avatarColor = avatarColor
        self.isKidsProfile = isKidsProfile
        self.isLocked = isLocked
    }
}

// MARK: - Sample Profiles
extension Profile {
    static let samples: [Profile] = [
        Profile(name: "Main",   avatarColor: .blue),
        Profile(name: "Kids",   avatarColor: .green,  isKidsProfile: true),
        Profile(name: "Guest",  avatarColor: .purple, isLocked: true),
        Profile(name: "Add",    avatarColor: .gray)
    ]
}
