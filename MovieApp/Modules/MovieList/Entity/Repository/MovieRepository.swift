//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import CoreData

protocol MovieRepository: Repository {
    var persistanceController: PersistanceController { get }
    
    var count: Int { get }
    
    func saveMovies(movies: [MovieEntity])
    func fetchMovieList() -> [MovieEntity]?
}

class MovieRepositoryImpl: MovieRepository {
    
    let persistanceController: PersistanceController
    
    init(persistanceController: PersistanceController) {
        self.persistanceController = persistanceController
    }
    
    var count: Int {
        return persistanceController.count
    }
    
    func saveMovies(movies: [MovieEntity]) {
        persistanceController.save(objects: movies)
    }
    
    func fetchMovieList() -> [MovieEntity]? {
        guard let movies = persistanceController.fetch() as? [MovieEntity], !movies.isEmpty else {
            return nil
        }
        return movies
    }
    
}
