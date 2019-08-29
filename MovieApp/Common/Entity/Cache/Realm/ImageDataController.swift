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
        return 0
    }
    
    func save(objects: [Any]) {
        
    }
    
    func fetch() -> [Any]? {
        return nil
    }
    
    func search(key: Any) -> Any? {
        return nil
    }
    
}
