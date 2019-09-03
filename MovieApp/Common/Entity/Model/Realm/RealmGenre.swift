//
//  RealmGenre.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RealmSwift

class RealmGenre: Object {
    
    let r_id = RealmOptional<Int>()
    @objc public dynamic var r_name: String?
    
    public override static func primaryKey() -> String? {
        return "r_id"
    }
    
}

extension RealmGenre: Genre {
    
    var id: Int? {
        get {
            return r_id.value
        }
        set(newValue) {
            r_id.value = newValue
        }
    }
    
    var name: String? {
        get {
            return r_name
        }
        set(newValue) {
            r_name = newValue
        }
    }
}
