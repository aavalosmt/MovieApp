//
//  UpcomingPresenter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class UpcomingPresenter: UpcomingPresenterProtocol {
    
    weak var view: UpcomingViewProtocol?
    var interactor: UpcomingInputInteractorProtocol
    var router: UpcomingRouterProtocol
    
    init(view: UpcomingViewProtocol,
         interactor: UpcomingInputInteractorProtocol,
         router: UpcomingRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - UpcomingOututInteractorProtocol

extension UpcomingPresenter: UpcomingOutputInteractorProtocol {
    
}
