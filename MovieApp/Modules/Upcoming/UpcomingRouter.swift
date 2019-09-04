//
//  UpcomingRouter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol UpcomingOutputRouterProtocol: class {
    func transitionDetail(from: Navigatable, movie: Movie)
}

class UpcomingRouter: UpcomingRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = UpcomingViewController()
        
        let interactor = UpcomingInteractor(
            getMovieListUseCase: GetMovieListImpl(
                service: MovieListWebService(),
                repository: MovieRepositoryImpl(
                    persistanceController: MovieDataController()
                ), type: .upcoming
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
        
        let router: UpcomingRouterProtocol & UpcomingOutputRouterProtocol = UpcomingRouter()
        
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

extension UpcomingRouter: UpcomingOutputRouterProtocol {
    
    func transitionDetail(from: Navigatable, movie: Movie) {
        let view = MovieDetailRouter.createModule(movie: movie)
        from.present(view, completion: nil)
    }
    
}
