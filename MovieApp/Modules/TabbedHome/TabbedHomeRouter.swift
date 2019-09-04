//
//  TabbedHomeRouter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class TabbedHomeRouter: TabbedHomeRouterProtocol {
    
    static func createModule(subModules: [TabBarViewProtocol]) -> UIViewController {
        let view = TabbedHomeViewController()
        view.tabControllers = subModules
        
        let interactor = TabbedHomeInteractor()
        let router = TabbedHomeRouter()
        
        let presenter = TabbedHomePresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
}
