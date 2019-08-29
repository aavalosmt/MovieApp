//
//  Image.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol Image {
    var data: Data? { get }
    var key: String? { get }
}

class ImageEntity: CodableEntity, Image {
    
    var data: Data?
    var key: String?
    
    init(data: Data?, key: String?) {
        self.data = data
        self.key = key
    }
    
}
