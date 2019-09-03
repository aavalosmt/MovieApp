//
//  PopularPresenter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class PopularPresenter: PopularPresenterProtocol {
    
    weak var view: PopularViewProtocol?
    var interactor: PopularInputInteractorProtocol
    var router: PopularRouterProtocol
    
    init(view: PopularViewProtocol,
         interactor: PopularInputInteractorProtocol,
         router: PopularRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - PopularOututInteractorProtocol

extension PopularPresenter: PopularOutputInteractorProtocol {
    
}
