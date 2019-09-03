//
//  Genre.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol Genre {
    var id: Int? { get }
    var name: String? { get }
}

class GenreEntity: CodableEntity, Genre {
    var id: Int?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
}
