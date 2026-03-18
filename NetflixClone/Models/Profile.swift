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
        Profile(name: "Tanakorn", avatarColor: Color(hex: "3498db")),
        Profile(name: "Aummy",   avatarColor: Color(hex: "1a5276")),
        Profile(name: "Bill",    avatarColor: Color(hex: "c0392b")),
        Profile(name: "Sakda",   avatarColor: Color(hex: "2980b9"))
    ]
}
