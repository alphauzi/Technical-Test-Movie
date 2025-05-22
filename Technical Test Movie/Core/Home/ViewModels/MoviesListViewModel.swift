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
    
    var page: Int = 1
    var isLastPage = false
    var requesting = false
    
    init(service: MoyaProvider<ApiService> = MoyaProvider<ApiService>()) {
        self.provider = service
    }
    
    func loadMore() {
        if self.requesting { return }
        if self.isLastPage == false {
            self.page += 1
            self.fetchMovie()
        }
    }
    
    func fetchMovie() {
        if self.requesting { return }
        self.requesting = true
        provider.rx.request(.nowPlaying(page: page)).subscribe{[weak self] result in
            self?.requesting = false
            switch result{
            case .success(let response):
                do {
                    let filterResponse = try response.filterSuccessfulStatusCodes()
                    let movieResponse = try filterResponse.map(MovieResponse.self, using: JSONDecoder())
                    if let totalPage = movieResponse.totalPages, let page = self?.page{
                        self?.isLastPage = page >= totalPage
                    }
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
