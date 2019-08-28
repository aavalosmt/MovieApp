//
//  MovieListPresenter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListPresenter: MovieListPresenterProtocol {
    
    private let movieChangeRelay: BehaviorRelay<[MovieEntity]>
    private let movieErrorChangeRelay: PublishRelay<Error>
    
    let didMovieListChange: Driver<[MovieEntity]>
    let didMovieErrorChange: Signal<Error>
    
    weak var view: MovieListViewProtocol?
    var interactor: MovieListInputInteractorProtocol
    var router: MovieListRouterProtocol
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(view: MovieListViewProtocol,
         interactor: MovieListInputInteractorProtocol,
         router: MovieListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.movieChangeRelay = BehaviorRelay<[MovieEntity]>(value: [])
        self.didMovieListChange = movieChangeRelay.asDriver()
        
        self.movieErrorChangeRelay = PublishRelay<Error>()
        self.didMovieErrorChange = movieErrorChangeRelay.asSignal()
    }
    
    func bind(viewDidLoad: Signal<Void>) {
        viewDidLoad.emit(onNext: { [weak self] text in
            guard let self = self else { return }
            self.getMovieList()
        }).disposed(by: disposeBag)
    }
    
    func getMovieList() {
        interactor
            .getMovieList()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case let .success(results):
                        self.movieChangeRelay.accept(results)
                    case let .error(error):
                        self.movieErrorChangeRelay.accept(error)
                    }
                }, onError: { [weak self] error in
                    guard let self = self else { return }
                    self.movieErrorChangeRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - MovieListOututInteractorProtocol

extension MovieListPresenter: MovieListOutputInteractorProtocol {
    
}
