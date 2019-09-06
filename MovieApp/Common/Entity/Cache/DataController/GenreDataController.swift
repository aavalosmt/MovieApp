//
//  GenreDataController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class GenreDataController: PersistanceController {
    
    let realmHandler: RealmHandler
    
    init(realmHandler: RealmHandler = .shared) {
        self.realmHandler = realmHandler
    }
    
    var count: Int {
        return fetch()?.count ?? 0
    }
    
    func count(predicate: String) -> Int {
        return fetch(predicate: predicate)?.count ?? 0
    }
    
    func save(objects: [Any]) {
        guard let genres = objects as? [GenreEntity] else {
            return
        }
        
        let realmGenres = genres.compactMap({ (genre) -> RealmGenre in
            let realmGenre = RealmGenre()
            realmGenre.id = genre.id
            realmGenre.name = genre.name
            
            return realmGenre
        })
        
        realmHandler.addObjects(objects: realmGenres, update: .all)
    }
    
    func fetch() -> [Any]? {
        let objects = realmHandler.getObjects(type: RealmGenre.self)
        
        let genres = objects?.compactMap({ (genre) -> GenreEntity? in
            guard let realmGenre = genre as? RealmGenre else {
                return nil
            }
            
            return GenreEntity(id: realmGenre.id, name: realmGenre.name)
        })
        
        return genres
    }
    
    func search(key: Any) -> Any? {
        guard let key = key as? Int else {
            return nil
        }
        
        guard let realmGenre = realmHandler.getObject(type: RealmGenre.self, forId: key) as? RealmGenre else {
            return nil
        }
        
        return GenreEntity(id: realmGenre.id, name: realmGenre.name)
    }
    
    func fetch(predicate: String) -> [Any]? {
        let objects = realmHandler.getObjects(type: RealmGenre.self, predicateFormat: predicate)
        
        let genres = objects?.compactMap({ (genre) -> GenreEntity? in
            guard let realmGenre = genre as? RealmGenre else {
                return nil
            }
            
            return GenreEntity(id: realmGenre.id, name: realmGenre.name)
        })
        
        return genres
    }
    
    func searchEntities(keyword: String) -> [Any]? {
        return nil
    }
    
}
