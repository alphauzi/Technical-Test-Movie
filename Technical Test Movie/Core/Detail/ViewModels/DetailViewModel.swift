//
//  DetailViewModel.swift
//  Technical Test Movie
//
//  Created by Yusron Alfauzi on 21/05/25.
//

import Foundation
import Moya
import RxSwift
import RxMoya

class DetailViewModel {
    
    private let provider: MoyaProvider<ApiService>
    private var bag = DisposeBag()
    
    var trailerResponse = PublishSubject<[Trailer]>()
    var reviewResponse = PublishSubject<[Review]>()
    
    var page: Int = 1
    var isLastPage = false
    var requesting = false
    
    init(service: MoyaProvider<ApiService> = MoyaProvider<ApiService>()) {
        self.provider = service
    }
    
    func loadMore(id: Int) {
        if self.requesting { return }
        if self.isLastPage == false {
            self.page += 1
            self.fetchReview(id: id)
        }
    }
    
    func fetchTrailer(id: Int) {
        provider.rx.request(.trailer(id: id)).subscribe{[weak self] result in
            switch result{
            case .success(let response):
                do {
                    let filterResponse = try response.filterSuccessfulStatusCodes()
                    let trailerResponse = try filterResponse.map(TrailerResponse.self, using: JSONDecoder())
                    self?.trailerResponse.onNext(trailerResponse.trailer)
                } catch let error {
                    print(error.localizedDescription)
                }
             
            case .failure(let error):
                print(error)
            }
        }
        .disposed(by: bag)
    }
    
    func fetchReview(id: Int) {
        if self.requesting { return }
        self.requesting = true
        provider.rx.request(.review(id: id, page: page)).subscribe{[weak self] result in
            self?.requesting = false
            switch result{
            case .success(let response):
                do {
                    let filterResponse = try response.filterSuccessfulStatusCodes()
                    let reviewResponse = try filterResponse.map(ReviewResponse.self, using: JSONDecoder())
                    if let totalPage = reviewResponse.totalPages, let page = self?.page{
                        self?.isLastPage = page >= totalPage
                    }
                    self?.reviewResponse.onNext(reviewResponse.reviews)
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
