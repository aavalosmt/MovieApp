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
        return getHomeTabModule()
    }
    
    static func startLoader() -> UIViewController {
        return LoaderRouter.createModule()
    }
    
    private static func getHomeTabModule() -> UIViewController {
        var subModules: [TabBarViewProtocol] = []
        
        let modules: [TabBarViewProtocol] = [
            PopularRouter.createModule(),
            TopRatedRouter.createModule(),
            UpcomingRouter.createModule()
        ].compactMap({ (module) -> TabBarViewProtocol? in
            return module as? TabBarViewProtocol
        })
        
        subModules.append(contentsOf: modules)
        
        return TabbedHomeRouter.createModule(subModules: subModules)
    }
    
}
