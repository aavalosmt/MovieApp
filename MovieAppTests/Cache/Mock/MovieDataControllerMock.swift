//
//  MovieDataControllerMock.swift
//  MovieAppTests
//
//  Created by Aldo Antonio Martinez Avalos on 9/6/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

@testable import MovieApp

// Mock that simulates persistance controller bridge

class MovieDataControllerMock: PersistanceController {
    
    var movies: [Movie] = []
    
    var count: Int {
        return movies.count
    }
    
    func count(predicate: String) -> Int {
        return movies.count
    }
    
    func save(objects: [Any]) {
        guard let objects = objects as? [Movie] else {
            return
        }
        
        movies.append(contentsOf: objects)
    }
    
    func fetch() -> [Any]? {
        return movies
    }
    
    func search(key: Any) -> Any? {
        guard let key = key as? String else {
            return nil
        }
        return movies.first(where: { $0.title == key })
    }
    
    func fetch(predicate: String) -> [Any]? {
        return nil
    }
    
    func searchEntities(keyword: String) -> [Any]? {
        return nil
    }
    
}
