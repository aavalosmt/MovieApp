//
//  MovieDetailPresenter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/30/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    weak var view: MovieDetailViewProtocol?
    var interactor: MovieDetailInputInteractorProtocol
    var router: MovieDetailRouterProtocol
    
    let movie: Movie
    
    init(view: MovieDetailViewProtocol,
         interactor: MovieDetailInputInteractorProtocol,
         router: MovieDetailRouterProtocol,
         movie: Movie) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.movie = movie
    }
    
}

// MARK: - MovieDetailOututInteractorProtocol

extension MovieDetailPresenter: MovieDetailOutputInteractorProtocol {
    
}
