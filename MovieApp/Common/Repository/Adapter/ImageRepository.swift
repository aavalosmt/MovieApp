//
//  ImageRepository.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol ImageRepository: Repository {
    var persistanceController: PersistanceController { get }
    
    func saveImages(images: [ImageEntity], size: ImageSize)
    func search(key: String, size: ImageSize) -> ImageEntity?
}

class ImageRepositoryImpl: ImageRepository {
    
    let persistanceController: PersistanceController
    
    init(persistanceController: PersistanceController) {
        self.persistanceController = persistanceController
    }
    
    func saveImages(images: [ImageEntity], size: ImageSize) {
        let images = images.map({ image -> Image in
            image.key = (image.key ?? "") + "_" + size.rawValue
            return image
        })
        persistanceController.save(objects: images)
    }
    
    func search(key: String, size: ImageSize) -> ImageEntity? {
        return persistanceController.search(key: key + "_" + size.rawValue) as? ImageEntity
    }
}
