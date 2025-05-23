//
//  MoviesListViewModelTest.swift
//  Technical Test MovieTests
//
//  Created by Yusron Alfauzi on 23/05/25.
//

import XCTest
import Moya
import RxSwift

@testable import Technical_Test_Movie

final class MoviesListViewModelTest: XCTestCase {
    let disposeBag = DisposeBag()
    
    func test_fetchMovie_returnsFailureNetworkError() {
        let sut = makeSUT(sampleResponseClosure:  { .networkError(NSError()) })
        let expectation = XCTestExpectation(description: "Wait for error message to be emitted")
        var didReceiveError = false
        
        sut.errorMessage
            .subscribe(onNext: {
                didReceiveError = true
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.fetchMovie()

        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(didReceiveError, "Expected errorMessage to emit value on network error")
    }
    
    func test_fetchMovie_returnsSuccessWithValidJSON() {
        let sut = makeSUT(sampleResponseClosure: { .networkResponse(200, self.ValidJSONFormatData())})
        let expectation = expectation(description: "Movie data received")
        var receivedMovies: [Movie] = []

        sut.movieResponse
            .subscribe(onNext: { movies in
                receivedMovies = movies
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.fetchMovie()

        wait(for: [expectation], timeout: 2.0)
        guard let movie = receivedMovies.first else {
            return XCTFail("Expected movie but got empty array")
        }

        XCTAssertEqual(movie.id, 950387)
        XCTAssertEqual(movie.backdropPath, "/2Nti3gYAX513wvhp8IiLL6ZDyOm.jpg")
        XCTAssertEqual(movie.posterPath, "/yFHHfHcUgGAxziP1C3lLt0q2T4s.jpg")
        XCTAssertEqual(movie.releaseDate, "2025-03-31")
        XCTAssertEqual(movie.title, "A Minecraft Movie")
        XCTAssertEqual(movie.voteAverage, 6.518)
        XCTAssertEqual(movie.voteCount, 1338)
        XCTAssertEqual(movie.popularity, 757.1254)
        XCTAssertEqual(movie.overview, "Four misfits find themselves struggling with ordinary problems when they are suddenly pulled through a mysterious portal into the Overworld: a bizarre, cubic wonderland that thrives on imagination. To get back home, they'll have to master this world while embarking on a magical quest with an unexpected, expert crafter, Steve.")
    }
    
    func test_loadMore_increasesPageAndFetchesMovie() {
        let expectation = expectation(description: "fetchMovie called")
        let sut = makeSUT(sampleResponseClosure: { .networkResponse(200, self.ValidJSONFormatData()) })
        var receivedMovies: [Movie] = []
        
        sut.movieResponse
            .subscribe(onNext: { movies in
                receivedMovies = movies
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.loadMore()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.page, 2)
        XCTAssertEqual(receivedMovies.count, 2)
        XCTAssertEqual(receivedMovies.first?.title, "A Minecraft Movie")
    }
    
    func test_loadMore_doesNothing_whenIsLastPageTrue() {
        let sut = makeSUT(sampleResponseClosure: { .networkResponse(200, self.ValidJSONFormatData()) })
        sut.isLastPage = true
        
        var didFetchMovie = false
        sut.movieResponse
            .subscribe(onNext: { _ in
                didFetchMovie = true
            })
            .disposed(by: disposeBag)

        sut.loadMore()
        
        XCTAssertEqual(sut.page, 1)
        XCTAssertFalse(didFetchMovie)
    }

    func test_loadMore_doesNothing_whenRequestingTrue() {
        let sut = makeSUT(sampleResponseClosure: { .networkResponse(200, self.ValidJSONFormatData()) })
        sut.requesting = true
        
        var didFetchMovie = false
        sut.movieResponse
            .subscribe(onNext: { _ in
                didFetchMovie = true
            })
            .disposed(by: disposeBag)

        sut.loadMore()
        
        XCTAssertEqual(sut.page, 1)
        XCTAssertFalse(didFetchMovie)
    }


    // MARK: - Helpers
    private func makeSUT(sampleResponseClosure: @escaping Endpoint.SampleResponseClosure) -> MoviesListViewModel{
        let customEndpointClosure = { (target: ApiService) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: sampleResponseClosure,
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        
        let stubbingProvider = MoyaProvider<ApiService>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let sut = MoviesListViewModel(service: stubbingProvider)
        return sut
    }
    
    private func ValidJSONFormatData() -> Data{
        let ValidJSONFormatData = """
        {
          "dates": {
            "maximum": "2025-05-28",
            "minimum": "2025-04-16"
          },
          "page": 1,
          "results": [
            {
              "adult": false,
              "backdrop_path": "/2Nti3gYAX513wvhp8IiLL6ZDyOm.jpg",
              "genre_ids": [10751, 35, 12, 14, 28],
              "id": 950387,
              "original_language": "en",
              "original_title": "A Minecraft Movie",
              "overview": "Four misfits find themselves struggling with ordinary problems when they are suddenly pulled through a mysterious portal into the Overworld: a bizarre, cubic wonderland that thrives on imagination. To get back home, they'll have to master this world while embarking on a magical quest with an unexpected, expert crafter, Steve.",
              "popularity": 757.1254,
              "poster_path": "/yFHHfHcUgGAxziP1C3lLt0q2T4s.jpg",
              "release_date": "2025-03-31",
              "title": "A Minecraft Movie",
              "video": false,
              "vote_average": 6.518,
              "vote_count": 1338
            },
            {
              "adult": false,
              "backdrop_path": "/j0NUh5irX7q2jIRtbLo8TZyRn6y.jpg",
              "genre_ids": [27, 9648],
              "id": 574475,
              "original_language": "en",
              "original_title": "Final Destination Bloodlines",
              "overview": "Plagued by a violent recurring nightmare, college student Stefanie heads home to track down the one person who might be able to break the cycle and save her family from the grisly demise that inevitably awaits them all.",
              "popularity": 525.7559,
              "poster_path": "/6WxhEvFsauuACfv8HyoVX6mZKFj.jpg",
              "release_date": "2025-05-09",
              "title": "Final Destination Bloodlines",
              "video": false,
              "vote_average": 7.145,
              "vote_count": 327
            }
          ],
          "total_pages": 263,
          "total_results": 5248
        }
        """.data(using: .utf8)!
        return ValidJSONFormatData
    }
}
