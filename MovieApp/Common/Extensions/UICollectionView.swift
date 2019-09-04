//
//  UICollectionView.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register(identifier: String) {
        register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
}
