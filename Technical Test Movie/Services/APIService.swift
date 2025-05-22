//
//  APIService.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 21/05/25.
//

import Foundation
import Moya

enum ApiService{
    case nowPlaying(page: Int)
    case trailer(id: Int)
    case review(id: Int, page: Int)
}

extension ApiService: TargetType{
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
  
    var path: String {
        switch self{
        case .nowPlaying:
            return "/movie/now_playing"
        case .trailer(let id):
            return "/movie/\(id)/videos"
        case .review(let id, _):
            return "/movie/\(id)/reviews"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .nowPlaying, .trailer, .review:
            return .get
        }
    }
    
    var sampleData: Data{
        switch self {
        case .nowPlaying, .trailer, .review:
            return Data()
        }
    }
    
    var task: Moya.Task {
        switch self{
        case .nowPlaying(let page), .review(_, let page):
            return .requestParameters(
                parameters: [
                    "language": "en-US",
                    "page": page,
                    "api_key": "898ad7c5f67300351bbf111191d3b3aa"
                ], encoding: URLEncoding.default
            )
        case .trailer:
            return .requestParameters(
                parameters: [
                    "language": "en-US",
                    "api_key": "898ad7c5f67300351bbf111191d3b3aa"
                ], encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
}
