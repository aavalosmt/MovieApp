//
//  GenreRepository.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol GenreRepository: Repository {
    var persistanceController: PersistanceController { get }
    var count: Int { get }
    
    func saveGenres(genres: [GenreEntity])
    func fetch() -> [GenreEntity]?
}

class GenreRepositoryImpl: GenreRepository {
    
    let persistanceController: PersistanceController
    
    var count: Int {
        return persistanceController.count
    }
    
    init(persistanceController: PersistanceController) {
        self.persistanceController = persistanceController
    }
    
    func saveGenres(genres: [GenreEntity]) {
        persistanceController.save(objects: genres)
    }
    
    func fetch() -> [GenreEntity]? {
        guard let genres = persistanceController.fetch() as? [GenreEntity], !genres.isEmpty else {
            return nil
        }
        return genres
    }
}
