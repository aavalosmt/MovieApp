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
    func fetchMovieList() -> [MovieEntity]
}

class MovieRepositoryImpl: MovieRepository {
    
    func fetchMovieList() -> [MovieEntity] {
        //let movies: [NSManagedObject] = []
        return []
    }
    
}
