//
//  GenreListResponse.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class GenreListResponse: CodableEntity {
    
    var genres: [GenreEntity]
    
    init(genres: [GenreEntity]) {
        self.genres = genres
    }
    
    enum CodingKeys: String, CodingKey {
        case genres
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        genres = try container.decode([GenreEntity].self, forKey: .genres)
    }
    
}
