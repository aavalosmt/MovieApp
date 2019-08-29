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
    
    func saveImages(images: [ImageEntity])
    func search(key: String) -> ImageEntity?
}

class ImageRepositoryImpl: ImageRepository {
    
    let persistanceController: PersistanceController
    
    init(persistanceController: PersistanceController) {
        self.persistanceController = persistanceController
    }
    
    func saveImages(images: [ImageEntity]) {
        persistanceController.save(objects: images)
    }
    
    func search(key: String) -> ImageEntity? {
        return persistanceController.search(key: key) as? ImageEntity
    }
}
