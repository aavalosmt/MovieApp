//
//  MovieListResponse.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class MovieListResponse: CodableEntity {

    var results: [MovieEntity]
    
    init(results: [MovieEntity]) {
        self.results = results
    }
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode([MovieEntity].self, forKey: .results)
    }
    
}
