//
//  Review.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 22/05/25.
//

import Foundation

struct ReviewResponse: Codable {
    let reviews: [Review]
    
    private enum CodingKeys: String, CodingKey {
        case reviews = "results"
    }
}


struct Review: Codable {
    let author: String?
    let authorDetails: AuthorDetails?
    let content, createdAt, id: String?

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
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
