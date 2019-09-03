//
//  TopRatedRouter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class TopRatedRouter: TopRatedRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = TopRatedViewController()
        
        let interactor = TopRatedInteractor()
        let router = TopRatedRouter()
        
        let presenter = TopRatedPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
}
