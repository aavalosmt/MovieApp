//
//  MovieListServiceTest.swift
//  MovieAppTests
//
//  Created by Aldo Antonio Martinez Avalos on 9/6/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import XCTest
@testable import MovieApp

class ProductListServiceTests: XCTestCase {
    
    var stub: GeneralTestsStubSetup!
    var service: MovieListService!

    override func setUp() {
        super.setUp()
        stub = GeneralTestsStubSetup()
        service = MovieListWebService()
    }
    
    override func tearDown() {
        super.tearDown()
        stub = nil
        service = nil
    }
    
    func testThatRetrievesProductsFromService() {
        let expectation = self.expectation(description: "GetMovies")
        var movieList: [Movie] = []
        service.getMovieList(page: 1, type: .popular, completion: { response in
            switch response {
            case .success(let entity):
                if let entity = entity as? MovieListResponse {
                    movieList.append(contentsOf: entity.results)
                }
            default: break
            }
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 30.0)
        XCTAssertTrue(!movieList.isEmpty)
    }
    
    private func setupStub() {
        let url = EndpointProvider.shared.url(forEndpoint: .MovieList(type: .popular))
        let jsonFile = CommonUnitTestsConstants.Stub.movieListSuccessResponseJson.rawValue
        stub.registerCustomStub(for: url, resource: jsonFile, status: .OK, isDown: false)
    }
}
