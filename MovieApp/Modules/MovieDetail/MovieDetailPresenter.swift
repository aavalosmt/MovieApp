//
//  MovieDetailPresenter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/30/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    // Outputs
    
    let imageChanged: Signal<(Int, UIImage?)>
    let module: Signal<MovieDetailModule>

    // Inputs
    
    let viewDidLoadTrigger: PublishSubject<Void> = PublishSubject<Void>()
    let imageNeededTrigger: PublishSubject<(Int, String)> = PublishSubject<(Int, String)> ()
    
    // Aux relay
    
    private let imageChangeRelay: PublishRelay<(Int, UIImage?)> = PublishRelay<(Int, UIImage?)>()
    private let moduleChangeRelay: PublishRelay<MovieDetailModule> = PublishRelay<MovieDetailModule>()
    
    weak var view: MovieDetailViewProtocol?
    var interactor: MovieDetailInputInteractorProtocol
    var router: MovieDetailRouterProtocol
    private let factory: MovieDetailModulesFactory
    private let disposeBag: DisposeBag = DisposeBag()

    let movie: Movie
    
    init(view: MovieDetailViewProtocol,
         interactor: MovieDetailInputInteractorProtocol,
         router: MovieDetailRouterProtocol,
         movie: Movie,
         factory: MovieDetailModulesFactory) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.movie = movie
        self.factory = factory
        
        self.imageChanged = imageChangeRelay.asSignal(onErrorJustReturn: (-1, nil))
        self.module = moduleChangeRelay.asSignal()
        
        viewDidLoadTrigger
            .asSignal(onErrorJustReturn: ())
            .emit(onNext: { [weak self] text in
                guard let self = self else { return }
                self.getModules()
            }).disposed(by: disposeBag)
        
        self.factory.moduleCreated
                    .asObservable()
                    .bind(to: moduleChangeRelay)
                    .disposed(by: disposeBag)
    }
    
    private func getModules() {
        self.factory.getModules(for: movie)
    }
    
}

// MARK: - MovieDetailOututInteractorProtocol

extension MovieDetailPresenter: MovieDetailOutputInteractorProtocol {
    
}
