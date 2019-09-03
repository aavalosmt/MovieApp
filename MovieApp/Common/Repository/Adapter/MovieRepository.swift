//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol MovieRepository: Repository {
    var persistanceController: PersistanceController { get }
    
    var count: Int { get }
    
    func count(forPage page: Int, type: MovieListType) -> Int
    func saveMovies(movies: [MovieEntity])
    func fetchMovieList(type: MovieListType) -> [MovieEntity]?
    func fetchMovieList(forPage page: Int, type: MovieListType) -> [MovieEntity]?
}

class MovieRepositoryImpl: MovieRepository {
    
    let persistanceController: PersistanceController
    
    init(persistanceController: PersistanceController) {
        self.persistanceController = persistanceController
    }
    
    var count: Int {
        return persistanceController.count
    }
    
    func count(forPage page: Int, type: MovieListType) -> Int {
        return fetchMovieList(forPage: page, type: type)?.count ?? 0
    }
    
    func saveMovies(movies: [MovieEntity]) {
        persistanceController.save(objects: movies)
    }
    
    func fetchMovieList(type: MovieListType) -> [MovieEntity]? {
        guard let movies = (persistanceController.fetch() as? [MovieEntity])?.filter({ movie in
            
            return movie.listTypes?.contains(type) ?? false
        }) else {
            return nil
        }
        return movies
    }
    
    func fetchMovieList(forPage page: Int, type: MovieListType) -> [MovieEntity]? {
        let pagePredicate = String(format: "(r_page = %d)", page, type.rawValue)
        
        guard let movies = (persistanceController.fetch(predicate: pagePredicate) as? [MovieEntity])?.filter({ movie in
            
            return movie.listTypes?.contains(type) ?? false
        }) else {
            return nil
        }
        return movies
    }
    
}
