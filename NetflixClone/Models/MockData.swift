import Foundation

// MARK: - Mock Data
// Replace thumbnailURL / backdropURL with real image URLs or local assets later
enum MockData {

    static let movies: [Movie] = [
        Movie(title: "Stranger Things",
              description: "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces and one strange little girl.",
              year: 2016, duration: "4 Seasons",
              matchPercentage: 98,
              genres: [.sciFi, .horror, .drama],
              cast: ["Millie Bobby Brown", "Finn Wolfhard", "Winona Ryder"],
              isNetflixOriginal: true, rating: "TV-14"),

        Movie(title: "Squid Game",
              description: "Hundreds of cash-strapped players accept a strange invitation to compete in children's games. Inside, a sinister agenda unfolds.",
              year: 2021, duration: "2 Seasons",
              matchPercentage: 97,
              genres: [.thriller, .drama, .action],
              cast: ["Lee Jung-jae", "Park Hae-soo"],
              isNetflixOriginal: true, rating: "TV-MA"),

        Movie(title: "Wednesday",
              description: "Smart, sarcastic and a little dead inside, Wednesday Addams investigates a murder spree while making new friends at Nevermore Academy.",
              year: 2022, duration: "2 Seasons",
              matchPercentage: 95,
              genres: [.horror, .comedy, .drama],
              cast: ["Jenna Ortega", "Gwendoline Christie"],
              isNetflixOriginal: true, rating: "TV-14"),

        Movie(title: "The Crown",
              description: "This drama follows the political rivalries and romance of Queen Elizabeth II's reign and the events that shaped the second half of the 20th century.",
              year: 2016, duration: "6 Seasons",
              matchPercentage: 92,
              genres: [.drama],
              cast: ["Claire Foy", "Olivia Colman", "Imelda Staunton"],
              isNetflixOriginal: true, rating: "TV-MA"),

        Movie(title: "Ozark",
              description: "A financial advisor drags his family from Chicago to the Missouri Ozarks, where he must launder money to appease a drug boss.",
              year: 2017, duration: "4 Seasons",
              matchPercentage: 94,
              genres: [.crime, .thriller, .drama],
              cast: ["Jason Bateman", "Laura Linney"],
              isNetflixOriginal: true, rating: "TV-MA"),

        Movie(title: "Black Mirror",
              description: "An anthology series exploring a twisted, high-tech near-future where humanity's greatest innovations and darkest instincts collide.",
              year: 2011, duration: "6 Seasons",
              matchPercentage: 91,
              genres: [.sciFi, .thriller, .drama],
              cast: ["Various"],
              isNetflixOriginal: false, rating: "TV-MA"),

        Movie(title: "Money Heist",
              description: "Eight thieves take hostages and lock themselves in the Royal Mint of Spain as a criminal mastermind manipulates the police.",
              year: 2017, duration: "5 Seasons",
              matchPercentage: 96,
              genres: [.crime, .action, .thriller],
              cast: ["Álvaro Morte", "Úrsula Corberó"],
              isNetflixOriginal: true, rating: "TV-MA"),

        Movie(title: "Bridgerton",
              description: "Wealth, lust and betrayal set against the backdrop of Regency-era England. The eight close-knit siblings of the Bridgerton family look for love.",
              year: 2020, duration: "3 Seasons",
              matchPercentage: 88,
              genres: [.romance, .drama],
              cast: ["Phoebe Dynevor", "Regé-Jean Page"],
              isNetflixOriginal: true, rating: "TV-MA")
    ]

    // MARK: - Content Rows
    static let homeRows: [ContentRow] = [
        ContentRow(title: "Continue Watching", movies: Array(movies.prefix(4))),
        ContentRow(title: "Netflix Originals", movies: movies.filter { $0.isNetflixOriginal }),
        ContentRow(title: "Trending Now",      movies: Array(movies.shuffled().prefix(6))),
        ContentRow(title: "Top Picks for You", movies: Array(movies.shuffled().prefix(5))),
        ContentRow(title: "Thriller Series",   movies: movies.filter { $0.genres.contains(.thriller) }),
        ContentRow(title: "Sci-Fi & Fantasy",  movies: movies.filter { $0.genres.contains(.sciFi) }),
        ContentRow(title: "Award-Winning",     movies: Array(movies.shuffled().prefix(5)))
    ]

    static let heroMovie: Movie = movies[0]
}
