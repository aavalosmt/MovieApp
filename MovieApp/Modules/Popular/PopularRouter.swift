//
//  PopularRouter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol PopularOutputRouterProtocol: class {
    func transitionSearch(from: TabBarViewProtocol)
}

class PopularRouter: PopularRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = PopularViewController()
        
        let interactor = PopularInteractor(
            getMovieListUseCase: GetMovieListImpl(
                service: MovieListWebService(),
                repository: MovieRepositoryImpl(
                    persistanceController: MovieDataController()
                ), type: .popular
            ),
            getGenreListUseCase: GetGenreListImpl(
                service: GenreListWebService(),
                repository: GenreRepositoryImpl(
                    persistanceController: GenreDataController()
                )
            ),
            imageProvider: ImageProvider(
                cache: ImageCache.shared,
                repository: ImageRepositoryImpl(
                    persistanceController: ImageDataController()
                )
            )
        )
        let router: PopularRouterProtocol & PopularOutputRouterProtocol = PopularRouter()
        
        let presenter = PopularPresenter(
            view: view,
            interactor: interactor,
            router: router,
            factory: PopularModulesFactory()
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
    func configuredViewController() -> UIViewController {
        return PopularRouter.createModule()
    }
    
}

extension PopularRouter: PopularOutputRouterProtocol {
    
    func transitionSearch(from: TabBarViewProtocol) {
        guard let origin = from as? (UIViewController & TabBarViewProtocol) else {
            return
        }
        
        let view = SearchMovieRouter.createModule()
        DispatchQueue.main.async {
            origin.container?.present(destination: view)
        }
    }
    
}
