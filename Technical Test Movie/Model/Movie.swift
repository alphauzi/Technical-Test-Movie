//
//  Movie.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 21/05/25.
//

import Foundation

struct MovieResponse: Codable{
    let movies: [Movie]
    let totalPages: Int?
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
        case totalPages = "total_pages"
    }
}

struct Movie: Codable {
    let backdropPath, overview, posterPath, releaseDate: String?
    let title: String?
    let voteAverage: Double?
    let voteCount, id: Int?
    let popularity: Double?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case id
        case popularity
    }
}
