//
//  MovieRepositoryTests.swift
//  MovieAppTests
//
//  Created by Aldo Antonio Martinez Avalos on 9/6/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import XCTest

@testable import MovieApp

class MovieRepositoryTests: XCTestCase {
    
    var repository: MovieRepository!
    
    override func setUp() {
        super.setUp()
        
        repository = MovieRepositoryImpl(
            persistanceController: MovieDataControllerMock()
        )
    }
    
    override func tearDown() {
        super.tearDown()
        
        repository = nil
    }
    
    func testThatCacheSavesMovies() {
        repository.saveMovies(movies: getTestMovies())
        XCTAssertEqual(repository.count, 3)
    }
    
    func testThatFetchesMovies() {
        repository.saveMovies(movies: getTestMovies())
        let movies = repository.fetchMovieList(type: .popular) ?? []
        XCTAssertFalse(movies.isEmpty)
    }
    
    private func getTestMovies() -> [MovieEntity] {
        var m1 = MovieEntity()
        var m2 = MovieEntity()
        var m3 = MovieEntity()
        
        m1.title = "1"
        m1.listTypes = Set<MovieListType>()
        m1.listTypes?.insert(.popular)
        
        m2.title = "2"
        m2.listTypes = Set<MovieListType>()
        m2.listTypes?.insert(.popular)

        m3.title = "3"
        m3.listTypes = Set<MovieListType>()
        m3.listTypes?.insert(.popular)
        
        return [m1, m2, m3]
    }
}
