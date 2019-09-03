//
//  TabbedHomePresenter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class TabbedHomePresenter: TabbedHomePresenterProtocol {
    
    weak var view: TabbedHomeViewProtocol?
    var interactor: TabbedHomeInputInteractorProtocol
    var router: TabbedHomeRouterProtocol
    
    init(view: TabbedHomeViewProtocol,
         interactor: TabbedHomeInputInteractorProtocol,
         router: TabbedHomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - TabbedHomeOututInteractorProtocol

extension TabbedHomePresenter: TabbedHomeOutputInteractorProtocol {
    
}
