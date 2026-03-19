import Foundation

// MARK: - Mock Data
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
              isNetflixOriginal: true, rating: "TV-MA"),

        // MARK: - Featured movies
        Movie(title: "Project Hail Mary",
              description: "Science teacher Ryland Grace wakes up on a spaceship light years from home with no recollection of who he is or how he got there. As his memory returns, he begins to uncover his mission: solve the riddle of the mysterious substance causing the sun to die out. He must call on his scientific knowledge and unorthodox ideas to save everything on Earth from extinction… but an unexpected friendship means he may not have to do it alone.",
              posterURL: "https://image.tmdb.org/t/p/w600_and_h900_face/cCx1m530ph5FmtabVVUpUchEmhe.jpg",
              backdropURLs: ["https://image.tmdb.org/t/p/original/8Tfys3mDZVp4tNoH2ktm06a0Tau.jpg"],
              logoURL: "https://image.tmdb.org/t/p/original/jvqIELbZctv3Jqtcc7Ic5of8vY7.png",
              year: 2026, duration: "2h 37m",
              matchPercentage: 97,
              genres: [.sciFi, .adventure, .mystery],
              cast: ["Ryan Gosling"],
              isNetflixOriginal: false, rating: "PG-13"),

        Movie(title: "One Battle After Another",
              description: "Washed-up revolutionary Bob exists in a state of stoned paranoia, surviving off-grid with his spirited, self-reliant daughter, Willa. When his evil nemesis resurfaces after 16 years and she goes missing, the former radical scrambles to find her, father and daughter both battling the consequences of his past.",
              posterURL: "https://image.tmdb.org/t/p/w600_and_h900_face/lbBWwxBht4JFP5PsuJ5onpMqugW.jpg",
              backdropURLs: ["https://image.tmdb.org/t/p/original/hiazLNa1UXuX35OTnMQRKOx3eTk.jpg"],
              logoURL: "https://image.tmdb.org/t/p/original/nuAwSIpWScRvVGBBSqXKsYEUdtp.png",
              year: 2025, duration: "2h 42m",
              matchPercentage: 89,
              genres: [.thriller, .crime, .comedy],
              cast: ["Leonardo DiCaprio", "Sean Penn", "Benicio del Toro"],
              isNetflixOriginal: false, rating: "R"),

        Movie(title: "Zootopia 2",
              description: "After cracking the biggest case in Zootopia's history, rookie cops Judy Hopps and Nick Wilde find themselves on the twisting trail of a great mystery when Gary De'Snake arrives and turns the animal metropolis upside down. To crack the case, Judy and Nick must go undercover to unexpected new parts of town, where their growing partnership is tested like never before.",
              posterURL: "https://image.tmdb.org/t/p/w600_and_h900_face/oJ7g2CifqpStmoYQyaLQgEU32qO.jpg",
              backdropURLs: ["https://image.tmdb.org/t/p/original/hVt4zQPfFc5oT9HCxPwKAMbAmIM.jpg"],
              logoURL: "https://image.tmdb.org/t/p/original/b2vTbsREFUNlUTkTsbLYGJBUlZH.png",
              year: 2025, duration: "1h 48m",
              matchPercentage: 93,
              genres: [.animation, .comedy, .adventure, .family, .mystery],
              cast: ["Ginnifer Goodwin", "Jason Bateman", "Ke Huy Quan"],
              isNetflixOriginal: false, rating: "PG"),

        Movie(title: "Hoppers",
              description: "Scientists have discovered how to 'hop' human consciousness into lifelike robotic animals, allowing people to communicate with animals as animals. Animal lover Mabel seizes an opportunity to use the technology, uncovering mysteries within the animal world beyond anything she could have imagined.",
              posterURL: "https://image.tmdb.org/t/p/w600_and_h900_face/xjtWQ2CL1mpmMNwuU5HeS4Iuwuu.jpg",
              backdropURLs: ["https://image.tmdb.org/t/p/original/x91763uieHs7u0TbJalHQDECAGj.jpg"],
              logoURL: "https://image.tmdb.org/t/p/original/qYuy5b3oKfhePVe4MNXJPTTTahW.png",
              year: 2026, duration: "1h 45m",
              matchPercentage: 91,
              genres: [.animation, .family, .sciFi, .comedy],
              cast: ["Piper Curda", "Bobby Moynihan", "Jon Hamm", "Dave Franco"],
              isNetflixOriginal: false, rating: "PG"),
    ]

    // MARK: - Backdrop movies (used in ProfilePickerView cycling backdrop)
    static let backdropMovies: [Movie] = movies.filter { !$0.backdropURLs.isEmpty }

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

    static let heroMovie: Movie = movies[8]
}
