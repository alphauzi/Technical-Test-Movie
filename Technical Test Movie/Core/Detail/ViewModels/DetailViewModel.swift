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
    
    init(service: MoyaProvider<ApiService> = MoyaProvider<ApiService>()) {
        self.provider = service
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
    
    func fetchReview(id: Int, page: Int) {
        provider.rx.request(.review(id: id, page: page)).subscribe{[weak self] result in
            switch result{
            case .success(let response):
                do {
                    let filterResponse = try response.filterSuccessfulStatusCodes()
                    let reviewResponse = try filterResponse.map(ReviewResponse.self, using: JSONDecoder())
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
