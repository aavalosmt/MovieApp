//
//  SearchMovieRouter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/5/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class SearchMovieRouter: SearchMovieRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = SearchMovieViewController()
        
        let interactor = SearchMovieInteractor(
            searchMovieUseCase: SearchMovieImpl(
                service: SearchMovieWebService(),
                repository: MovieRepositoryImpl(
                    persistanceController: MovieDataController()
                )
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
        
        let router = SearchMovieRouter()
        
        let presenter = SearchMoviePresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
}
