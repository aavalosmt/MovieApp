//
//  UIView.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

extension UIView {
    
    func configureConstraintsToBorder(with view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
}
