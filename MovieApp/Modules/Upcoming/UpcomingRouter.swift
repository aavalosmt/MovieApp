//
//  UpcomingRouter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class UpcomingRouter: UpcomingRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = UpcomingViewController()
        
        let interactor = UpcomingInteractor()
        let router = UpcomingRouter()
        
        let presenter = UpcomingPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
}
