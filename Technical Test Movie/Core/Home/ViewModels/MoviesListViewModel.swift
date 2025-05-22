//
//  MoviesListViewModel.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 21/05/25.
//

import Foundation
import Moya
import RxSwift
import RxMoya

class MoviesListViewModel {
    
    private let provider: MoyaProvider<ApiService>
    private var bag = DisposeBag()
    
    var movieResponse = PublishSubject<[Movie]>()
    
    init(service: MoyaProvider<ApiService> = MoyaProvider<ApiService>()) {
        self.provider = service
    }
    
    func fetchUsers(page: Int) {
        provider.rx.request(.nowPlaying(page: page)).subscribe{[weak self] result in
            switch result{
            case .success(let response):
                do {
                    let filterResponse = try response.filterSuccessfulStatusCodes()
                    let movieResponse = try filterResponse.map(MovieResponse.self, using: JSONDecoder())
                    self?.movieResponse.onNext(movieResponse.movies)
                } catch let error {
                    print(error.localizedDescription)
                }
             
            case .failure(let error):
                print(error)
            }
        }
        .disposed(by: bag)
    }
}  
