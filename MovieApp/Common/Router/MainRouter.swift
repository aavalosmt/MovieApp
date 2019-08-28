//
//  MainRouter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class MainRouter {
    
    static func startNavigation() -> UIViewController {
        return MovieListRouter.createModule()
    }
    
}
