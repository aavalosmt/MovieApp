//
//  MovieDetailRouter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/30/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class MovieDetailRouter: MovieDetailRouterProtocol {
    
    static func createModule(movie: Movie) -> UIViewController {
        let view = MovieDetailViewController()
        
        let interactor = MovieDetailInteractor()
        let router = MovieDetailRouter()
        
        let presenter = MovieDetailPresenter(
            view: view,
            interactor: interactor,
            router: router,
            movie: movie
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
    static func push(from: Navigatable, movie: Movie) {
        let view = createModule(movie: movie)
        from.push(view, animated: true)
    }
    
}
