//
//  TopRatedPresenter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class TopRatedPresenter: TopRatedPresenterProtocol {
    
    weak var view: TopRatedViewProtocol?
    var interactor: TopRatedInputInteractorProtocol
    var router: TopRatedRouterProtocol
    
    init(view: TopRatedViewProtocol,
         interactor: TopRatedInputInteractorProtocol,
         router: TopRatedRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - TopRatedOututInteractorProtocol

extension TopRatedPresenter: TopRatedOutputInteractorProtocol {
    
}
