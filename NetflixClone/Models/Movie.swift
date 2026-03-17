import Foundation

// MARK: - Movie Model
struct Movie: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let thumbnailURL: String
    let backdropURL: String
    let year: Int
    let duration: String
    let matchPercentage: Int
    let genres: [Genre]
    let cast: [String]
    let isNetflixOriginal: Bool
    let rating: String

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        thumbnailURL: String = "",
        backdropURL: String = "",
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
        self.thumbnailURL = thumbnailURL
        self.backdropURL = backdropURL
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
    case action     = "Action"
    case comedy     = "Comedy"
    case drama      = "Drama"
    case horror     = "Horror"
    case sciFi      = "Sci-Fi"
    case thriller   = "Thriller"
    case romance    = "Romance"
    case animation  = "Animation"
    case documentary = "Documentary"
    case crime      = "Crime"
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
