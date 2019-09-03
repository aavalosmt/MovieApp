//
//  Collection.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/1/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
