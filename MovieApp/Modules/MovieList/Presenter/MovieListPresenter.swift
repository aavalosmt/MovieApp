//
//  MovieListPresenter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class MovieListPresenter: MovieListPresenterProtocol {
    
    weak var view: MovieListViewProtocol?
    var interactor: MovieListInputInteractorProtocol
    var router: MovieListRouterProtocol
    
    init(view: MovieListViewProtocol,
         interactor: MovieListInputInteractorProtocol,
         router: MovieListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - MovieListOututInteractorProtocol

extension MovieListPresenter: MovieListOutputInteractorProtocol {
    
}
