//
//  LoaderRouter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class LoaderRouter: LoaderRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = LoaderViewController()
        
        let interactor = LoaderInteractor(
            getGenreListUseCase: GetGenreListImpl(
                service: GenreListWebService(),
                repository: GenreRepositoryImpl(
                    persistanceController: GenreDataController(
                        realmHandler: RealmHandler.shared
                    )
                )
            )
        )
        
        let router = LoaderRouter()
        
        let presenter = LoaderPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
}
