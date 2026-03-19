import Foundation

// MARK: - Movie Model
struct Movie: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let posterURL: String
    let backdropURLs: [String]
    let logoURL: String
    let year: Int
    let duration: String
    let matchPercentage: Int
    let genres: [Genre]
    let cast: [String]
    let isNetflixOriginal: Bool
    let rating: String

    /// Returns a random backdrop URL from the array, or empty string if none available
    var backdropURL: String { backdropURLs.randomElement() ?? "" }

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        posterURL: String = "",
        backdropURLs: [String] = [],
        logoURL: String = "",
        year: Int,
        duration: String,
        matchPercentage: Int,
        genres: [Genre] = [],
        cast: [String] = [],
        isNetflixOriginal: Bool = false,
        rating: String = "TV-MA"
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.posterURL = posterURL
        self.backdropURLs = backdropURLs
        self.logoURL = logoURL
        self.year = year
        self.duration = duration
        self.matchPercentage = matchPercentage
        self.genres = genres
        self.cast = cast
        self.isNetflixOriginal = isNetflixOriginal
        self.rating = rating
    }
}

// MARK: - Genre
enum Genre: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case action      = "Action"
    case adventure   = "Adventure"
    case animation   = "Animation"
    case comedy      = "Comedy"
    case crime       = "Crime"
    case documentary = "Documentary"
    case drama       = "Drama"
    case family      = "Family"
    case horror      = "Horror"
    case mystery     = "Mystery"
    case romance     = "Romance"
    case sciFi       = "Sci-Fi"
    case thriller    = "Thriller"
}

// MARK: - Content Row
struct ContentRow: Identifiable {
    let id: UUID
    let title: String
    let movies: [Movie]

    init(id: UUID = UUID(), title: String, movies: [Movie]) {
        self.id = id
        self.title = title
        self.movies = movies
    }
}
