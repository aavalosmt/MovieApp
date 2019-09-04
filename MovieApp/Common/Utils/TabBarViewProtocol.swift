//
//  TabBarViewProtocol.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol TabBarViewProtocol {
    
    var tabIcon: UIImage? { get }
    var tabTitle: String { get }
    
    var container: BasePagerContainerViewController<TabCollectionViewCell>? { get set }
    
}
