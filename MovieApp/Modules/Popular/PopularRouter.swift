//
//  PopularRouter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class PopularRouter: PopularRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = PopularViewController()
        
        let interactor = PopularInteractor()
        let router = PopularRouter()
        
        let presenter = PopularPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
    func configuredViewController() -> UIViewController {
        return PopularRouter.createModule()
    }
    
}
