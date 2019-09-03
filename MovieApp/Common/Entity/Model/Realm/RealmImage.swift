//
//  RealmImage.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/29/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RealmSwift

class RealmImage: Object {
    @objc public dynamic var r_key: String?
    @objc public dynamic var r_data: Data?
    
    public override static func primaryKey() -> String? {
        return "r_key"
    }
}

extension RealmImage: Image {
    
    var key: String? {
        get {
            return r_key
        }
        set(newValue) {
            return r_key = newValue
        }
    }
    
    var data: Data? {
        get {
            return r_data
        }
        set(newValue) {
            r_data = newValue
        }
    }
    
}
