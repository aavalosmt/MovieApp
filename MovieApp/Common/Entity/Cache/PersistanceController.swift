//
//  PersistanceController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol PersistanceController {
    
    var count: Int { get }
    
    func count(predicate: String) -> Int
    func save(objects: [Any]) 
    func fetch() -> [Any]?
    func search(key: Any) -> Any?
    func fetch(predicate: String) -> [Any]?
    func searchEntities(keyword: String) -> [Any]?
}
