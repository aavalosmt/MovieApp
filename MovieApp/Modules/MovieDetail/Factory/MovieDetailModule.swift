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
    case overview(description: String)
}

struct MovieDetailModule {
    var type: MovieDetailModuleType
    
    
}
