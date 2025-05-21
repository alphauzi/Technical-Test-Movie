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
}

extension ApiService: TargetType{
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self{
        case .nowPlaying:
            return "/movie/now_playing"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .nowPlaying:
            return .get
        }
    }
    
    var sampleData: Data{
        switch self {
        case .nowPlaying:
            return Data()
        }
    }
    
    var task: Moya.Task {
        switch self{
        case .nowPlaying(let page):
            return .requestParameters(
                parameters: [
                    "language": "en-US",
                    "page": page,
                    "api_key": "898ad7c5f67300351bbf111191d3b3aa"
                ], encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
}
