//
//  ImageDataController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/29/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class ImageDataController: PersistanceController {
    
    let realmHandler: RealmHandler
    
    init(realmHandler: RealmHandler = .shared) {
        self.realmHandler = realmHandler
    }
    
    var count: Int {
        return fetch()?.count ?? 0
    }
    
    func count(predicate: String) -> Int {
        return realmHandler.getObjects(type: RealmImage.self, predicateFormat: predicate)?.count ?? 0
    }
    
    func save(objects: [Any]) {
        guard let images = objects as? [ImageEntity] else {
            return
        }
        
        let realmImages = images.compactMap({ image -> RealmImage in
            let realmImage = RealmImage()
            realmImage.key = image.key
            realmImage.data = image.data
            
            return realmImage
        })
        
        realmHandler.addObjects(objects: realmImages, update: .all)
    }
    
    func fetch() -> [Any]? {
        let objects = realmHandler.getObjects(type: RealmImage.self)
        
        let images = objects?.compactMap({ realmImage -> ImageEntity? in
            guard let realmImage = realmImage as? RealmImage else {
                return nil
            }
            
            let entity = ImageEntity(data: realmImage.data, key: realmImage.key)
            return entity
        })
        
        return (images?.isEmpty ?? true) ? nil : images
    }
    
    func search(key: Any) -> Any? {
        guard let key = key as? String else {
            return nil
        }
        
        guard let realmImage = realmHandler.getObject(type: RealmImage.self, forKey: key) as? RealmImage else {
            return nil
        }
        
        return ImageEntity(data: realmImage.data, key: realmImage.key)
    }
    
    func fetch(predicate: String) -> [Any]? {
        return nil
    }
    
    func searchEntities(keyword: String) -> [Any]? {
        return nil
    }
    
}
