//
//  Review.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 22/05/25.
//

import Foundation

struct ReviewResponse: Codable {
    let reviews: [Review]
    let totalPages: Int?
    
    private enum CodingKeys: String, CodingKey {
        case reviews = "results"
        case totalPages = "total_pages"
    }
}


struct Review: Codable {
    let author: String?
    let authorDetails: AuthorDetails?
    let content, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
    }
}


struct AuthorDetails: Codable {
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case avatarPath = "avatar_path"
        case rating
    }
}
