//
//  MovieListRouter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class MovieListRouter: MovieListRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = MovieListViewController()
        
        let interactor = MovieListInteractor()
        let router = MovieListRouter()
        
        let presenter = MovieListPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
}
