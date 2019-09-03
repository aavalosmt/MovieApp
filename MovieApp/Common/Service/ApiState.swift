//
//  ApiState.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/30/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class ApiState {
    
    var page: Int
    
    init(page: Int = 0) {
        self.page = page
    }
    
    func reset() {
        self.page = 0
    }
    
    func increment() {
        self.page += 1
    }

}
