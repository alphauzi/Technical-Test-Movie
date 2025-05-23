//
//  DetailViewModelTest.swift
//  Technical Test MovieTests
//
//  Created by Yusron Alfauzi on 23/05/25.
//

import XCTest
import Moya
import RxSwift

@testable import Technical_Test_Movie

final class DetailViewModelTest: XCTestCase {
    let disposeBag = DisposeBag()
    
    // MARK: - Trailer
    func test_fetchTrailer_returnsFailureNetworkError() {
        let sut = makeSUT(sampleResponseClosure:  { .networkError(NSError()) })
        let expectation = XCTestExpectation(description: "Wait for error message to be emitted")
        var didReceiveError = false
        
        sut.errorMessage
            .subscribe(onNext: {
                didReceiveError = true
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.fetchTrailer(id: 950387)

        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(didReceiveError, "Expected errorMessage to emit value on network error")
    }
    
    func test_fetchTrailer_returnsSuccessWithValidJSON() {
        let sut = makeSUT(sampleResponseClosure: { .networkResponse(200, self.ValidJSONTrailer())})
        let expectation = expectation(description: "Movie data received")
        var receivedTrailer: [Trailer] = []

        sut.trailerResponse
            .subscribe(onNext: { trailer in
                receivedTrailer = trailer
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.fetchTrailer(id: 950387)

        wait(for: [expectation], timeout: 2.0)

        guard let trailer = receivedTrailer.first else {
            return XCTFail("Expected movie but got empty array")
        }

        XCTAssertEqual(trailer.key, "jR1YKRovXmM")
        XCTAssertEqual(trailer.name, "Behind the Scenes: Creepers, Zombies & Endermen Mobs")
    }
    
    // MARK: - Review
    func test_fetchReview_returnsFailureNetworkError() {
        let sut = makeSUT(sampleResponseClosure:  { .networkError(NSError()) })
        let expectation = XCTestExpectation(description: "Wait for error message to be emitted")
        var didReceiveError = false
        
        sut.errorMessage
            .subscribe(onNext: {
                didReceiveError = true
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.fetchReview(id: 950387)

        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(didReceiveError, "Expected errorMessage to emit value on network error")
    }
    
    func test_fetchReview_returnsSuccessWithValidJSON() {
        let sut = makeSUT(sampleResponseClosure: { .networkResponse(200, self.ValidJSONReview())})
        let expectation = expectation(description: "Movie data received")
        var receivedReviews: [Review] = []

        sut.reviewResponse
            .subscribe(onNext: { reviews in
                receivedReviews = reviews
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.fetchReview(id: 950387)

        wait(for: [expectation], timeout: 2.0)

        guard let review = receivedReviews.first else {
            return XCTFail("Expected movie but got empty array")
        }

        XCTAssertEqual(review.author, "CinemaSerf")
        XCTAssertEqual(review.createdAt, "2025-04-14T14:22:18.863Z")
        XCTAssertEqual(review.authorDetails?.avatarPath, "/yz2HPme8NPLne0mM8tBnZ5ZWJzf.jpg")
        XCTAssertEqual(review.authorDetails?.rating, 6)
        XCTAssertEqual(review.content, "Who doesn’t like a white woolly llama? Well that’s probably the highlight of this derivative CGI-fest that finds a quartet of geeks and gamers dragged through a magical portal to a world ruled by the evil “Malgosha”. Now she wants to use this glowing cube to escape from her dark and dingy “Overworld” realm and take over the peaceable and colourful real-world but she hasn’t banked on the tenacity of former gaming champion “Garrett” (Jason Momoa) and the geeky “Henry” (Sebastian Hansen) who reunite with the long trapped “Steve” (Jack Black) to save the day and the world. You don’t really need to know much about the video game to appreciate the simplicity of this, but then again I’m note sure you’d need to be much over 5 to appreciate it either. The visuals are engagingly 1980s with some references that did remind me a bit of “Back to the Future” (1985) meets “Dungeons & Dragons” and a decent soundtrack that allows Black to get straight into his element and prove that it is possible to entertain amidst what was undoubtedly (for him) a sea of green! Momoa isn’t afraid to send himself up both Danielle Brooks and Sebastian Henry seem to be ready to immerse themselves in this once in a lifetime opportunity to be in a big-budget movie without really having any lines to learn, cues to make or long sessions in the make up chair. As ever with these weakly written fantasies, the denouement is never in jeopardy but with so much enthusiasm on the screen for something that was, for many, an integral part of their growing up it’s difficult to be overly critical of something so shamelessly sentimental. What it isn’t, though, is funny and the laughs are few and far between so I think it’s best to just aim low and let the whole tide of your adolescence (if you are old enough) to wash over you before you leave the cinema, completely forget all about this and hope there isn’t a sequel.")
    }
    
    func test_loadMore_increasesPageAndFetchesReview() {
        let expectation = expectation(description: "fetchReview called")
        let sut = makeSUT(sampleResponseClosure: { .networkResponse(200, self.ValidJSONReview()) })
        var receivedReviews: [Review] = []
        
        sut.reviewResponse
            .subscribe(onNext: { reviews in
                receivedReviews = reviews
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.loadMore(id: 950387)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.page, 2)
        XCTAssertEqual(receivedReviews.count, 2)
        XCTAssertEqual(receivedReviews.first?.author, "CinemaSerf")
    }
    
    func test_loadMore_doesNothing_whenIsLastPageTrue() {
        let sut = makeSUT(sampleResponseClosure: { .networkResponse(200, self.ValidJSONReview()) })
        sut.isLastPage = true
        
        var didFetchReview = false
        sut.reviewResponse
            .subscribe(onNext: { _ in
                didFetchReview = true
            })
            .disposed(by: disposeBag)

        sut.loadMore(id: 950387)
        
        XCTAssertEqual(sut.page, 1)
        XCTAssertFalse(didFetchReview)
    }

    func test_loadMore_doesNothing_whenRequestingTrue() {
        let sut = makeSUT(sampleResponseClosure: { .networkResponse(200, self.ValidJSONReview()) })
        sut.requesting = true
        
        var didFetchReview = false
        sut.reviewResponse
            .subscribe(onNext: { _ in
                didFetchReview = true
            })
            .disposed(by: disposeBag)

        sut.loadMore(id: 950387)
        
        XCTAssertEqual(sut.page, 1)
        XCTAssertFalse(didFetchReview)
    }

    // MARK: - Helpers
    private func makeSUT(sampleResponseClosure: @escaping Endpoint.SampleResponseClosure) -> DetailViewModel{
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
        let sut = DetailViewModel(service: stubbingProvider)
        return sut
    }
    
    private func ValidJSONTrailer() -> Data{
        let ValidJSONFormatData = """
        {
          "id": 950387,
          "results": [
            {
              "iso_639_1": "en",
              "iso_3166_1": "US",
              "name": "Behind the Scenes: Creepers, Zombies & Endermen Mobs",
              "key": "jR1YKRovXmM",
              "site": "YouTube",
              "size": 1080,
              "type": "Behind the Scenes",
              "official": true,
              "published_at": "2025-05-22T12:01:19.000Z",
              "id": "682f21f012f93ded5a5ed48a"
            },
            {
              "iso_639_1": "en",
              "iso_3166_1": "US",
              "name": "Movie Clip - Jennifer Coolidge Meets Villager Nitwit",
              "key": "MuPyCZJc6W8",
              "site": "YouTube",
              "size": 1080,
              "type": "Clip",
              "official": true,
              "published_at": "2025-05-20T12:00:50.000Z",
              "id": "682c8754c78f4532bf2f7a78"
            }
          ]
        }
        """.data(using: .utf8)!
        return ValidJSONFormatData
    }
    
    private func ValidJSONReview() -> Data{
        let ValidJSONFormatData = """
        {
          "id": 950387,
          "page": 1,
          "results": [
            {
              "author": "CinemaSerf",
              "author_details": {
                "name": "CinemaSerf",
                "username": "Geronimo1967",
                "avatar_path": "/yz2HPme8NPLne0mM8tBnZ5ZWJzf.jpg",
                "rating": 6
              },
              "content": "Who doesn’t like a white woolly llama? Well that’s probably the highlight of this derivative CGI-fest that finds a quartet of geeks and gamers dragged through a magical portal to a world ruled by the evil “Malgosha”. Now she wants to use this glowing cube to escape from her dark and dingy “Overworld” realm and take over the peaceable and colourful real-world but she hasn’t banked on the tenacity of former gaming champion “Garrett” (Jason Momoa) and the geeky “Henry” (Sebastian Hansen) who reunite with the long trapped “Steve” (Jack Black) to save the day and the world. You don’t really need to know much about the video game to appreciate the simplicity of this, but then again I’m note sure you’d need to be much over 5 to appreciate it either. The visuals are engagingly 1980s with some references that did remind me a bit of “Back to the Future” (1985) meets “Dungeons & Dragons” and a decent soundtrack that allows Black to get straight into his element and prove that it is possible to entertain amidst what was undoubtedly (for him) a sea of green! Momoa isn’t afraid to send himself up both Danielle Brooks and Sebastian Henry seem to be ready to immerse themselves in this once in a lifetime opportunity to be in a big-budget movie without really having any lines to learn, cues to make or long sessions in the make up chair. As ever with these weakly written fantasies, the denouement is never in jeopardy but with so much enthusiasm on the screen for something that was, for many, an integral part of their growing up it’s difficult to be overly critical of something so shamelessly sentimental. What it isn’t, though, is funny and the laughs are few and far between so I think it’s best to just aim low and let the whole tide of your adolescence (if you are old enough) to wash over you before you leave the cinema, completely forget all about this and hope there isn’t a sequel.",
              "created_at": "2025-04-14T14:22:18.863Z",
              "id": "67fd1a1a61b1c4bb32993342",
              "updated_at": "2025-04-14T14:22:18.991Z",
              "url": "https://www.themoviedb.org/review/67fd1a1a61b1c4bb32993342"
            },
            {
              "author": "Jm_15",
              "author_details": {
                "name": "",
                "username": "Jm_15",
                "avatar_path": null,
                "rating": null
              },
              "content": "Chickey Jockey is so fun to watch. I love it so much",
              "created_at": "2025-05-16T02:23:40.360Z",
              "id": "6826a1ac38d830e983768136",
              "updated_at": "2025-05-16T22:43:19.121Z",
              "url": "https://www.themoviedb.org/review/6826a1ac38d830e983768136"
            }
          ],
          "total_pages": 1,
          "total_results": 4
        }
        """.data(using: .utf8)!
        return ValidJSONFormatData
    }
}
