//
//  MovieDetailModule.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

enum MovieDetailModuleType {
    case poster(path: String)
    case rating(rating: Double)
    case overview
}

protocol MovieDetailModuleProtocol {
    var type: MovieDetailModuleType { get }
}

struct MovieDetailModule: MovieDetailModuleProtocol {
    var type: MovieDetailModuleType
}

struct MovieDetailOverviewModule: MovieDetailModuleProtocol {
    var type: MovieDetailModuleType
    
    var title: String
    var description: String
    var rating: Double
    var releaseDate: String
    var genres: [String]
}
