import Foundation

extension String {

    // "2h 14m" helper
    static func duration(hours: Int, minutes: Int) -> String {
        switch (hours, minutes) {
        case (0, let m): return "\(m)m"
        case (let h, 0): return "\(h)h"
        default:         return "\(hours)h \(minutes)m"
        }
    }

    // Truncate with ellipsis
    func truncated(to length: Int) -> String {
        count > length ? String(prefix(length)) + "…" : self
    }
}
