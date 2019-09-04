//
//  PopularModule.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

enum PopularModuleType: Hashable {
    case search
    case genre(genres: [Genre])
    case starred(movie: Movie?)
    case carousel(movies: [Movie])
    case list(movies: [Movie])
    
    var capacity: Int {
        switch self {
        case .genre:
            return 100
        case .starred:
            return 1
        case .carousel:
            return 9
        case .list:
            return 1000
        case .search:
            return 0
        }
    }
    
    var id: Int {
        switch self {
        case .genre:
            return -1
        case .starred:
            return 1
        case .carousel:
            return 2
        case .list:
            return 3
        case .search:
            return 0
        }
    }
    
    static func == (lhs: PopularModuleType, rhs: PopularModuleType) -> Bool {
        return lhs.id == rhs.id
    }
    
    var hashValue: Int {
        return id.hashValue
    }
    
    static func fromId(id: Int) -> PopularModuleType? {
        switch id {
        case 0:
            return .search
        case 1:
            return .starred(movie: nil)
        case 2:
            return .carousel(movies: [])
        case 3:
            return .list(movies: [])
        default: return nil
        }
    }
    
    func withMovies(movies: [Movie]) -> PopularModuleType? {
        switch self {
        case .starred:
            return .starred(movie: movies.first)
        case .carousel:
            return .carousel(movies: movies)
        case .list:
            return .list(movies: movies)
        default: return nil
        }
    }
    
}

struct PopularModule {
    
    var type: PopularModuleType

    init(type: PopularModuleType) {
        self.type = type
    }
    
}
