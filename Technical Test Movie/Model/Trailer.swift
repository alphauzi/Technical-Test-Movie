//
//  Trailer.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 21/05/25.
//

import Foundation

struct TrailerResponse: Codable{
    let trailer: [Trailer]
    
    private enum CodingKeys: String, CodingKey {
        case trailer = "results"
    }
}

struct Trailer: Codable {
    let name, key: String
}
