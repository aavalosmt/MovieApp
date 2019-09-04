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
        
        let interactor = MovieDetailInteractor(
            imageProvider: ImageProvider(
                cache: ImageCache.shared,
                repository: ImageRepositoryImpl(
                    persistanceController: ImageDataController()
                )
            )
        )
        
        let router = MovieDetailRouter()
        
        let presenter = MovieDetailPresenter(
            view: view,
            interactor: interactor,
            router: router,
            movie: movie,
            factory: MovieDetailModulesFactory()
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
}
