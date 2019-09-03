//
//  MovieListPresenter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieListPresenter: MovieListPresenterProtocol {
    
    private let movieChangeRelay: BehaviorRelay<[MovieEntity]>
    private let movieErrorChangeRelay: PublishRelay<Error>
    private let imageChangeRelay: BehaviorRelay<(index: Int, image: UIImage?)>
    
    let didMovieListChange: Driver<[MovieEntity]>
    let didMovieErrorChange: Signal<Error>
    let didImageChange: Driver<(index: Int, image: UIImage?)>
    
    let reachedBottomTrigger: PublishSubject<Void> = PublishSubject<Void>()
    let viewDidLoadTrigger: PublishSubject<Void> = PublishSubject<Void>()
    
    weak var view: MovieListViewProtocol?
    var interactor: MovieListInputInteractorProtocol
    var router: MovieListRouterProtocol & MovieListRouterOutputProtocol
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(view: MovieListViewProtocol,
         interactor: MovieListInputInteractorProtocol,
         router: MovieListRouterProtocol & MovieListRouterOutputProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.movieChangeRelay = BehaviorRelay<[MovieEntity]>(value: [])
        self.didMovieListChange = movieChangeRelay.asDriver()
        
        self.movieErrorChangeRelay = PublishRelay<Error>()
        self.didMovieErrorChange = movieErrorChangeRelay.asSignal()

        let value: (Int, UIImage?) = (-1, nil)
        self.imageChangeRelay = BehaviorRelay<(index: Int, image: UIImage?)>(value: value)
        self.didImageChange = imageChangeRelay.asDriver()
        
        viewDidLoadTrigger.asSignal(onErrorJustReturn: ())
            .emit(onNext: { [weak self] text in
                    guard let self = self else { return }
                self.getMovieList()
                }
            ).disposed(by: disposeBag)
        
        reachedBottomTrigger.asObservable()
            .debounce(0.2, scheduler: SharingScheduler.make())
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                self.getMovieList()
        }).disposed(by: disposeBag)
    }
    
    func bind(imageNeededTrigger: Signal<(Int, String)>, selectRowTrigger: Signal<Movie>) {
        imageNeededTrigger.emit(onNext: { [weak self] (index, path) in
            guard let self = self else { return }
            self.getImage(forPath: path, index: index)
        }).disposed(by: disposeBag)
        
        selectRowTrigger.emit(onNext: { [weak self] movie in
            guard let self = self, let view = self.view as? Navigatable else { return }
            self.router.transitionDetail(from: view, movie: movie)
        }).disposed(by: disposeBag)
    }
    
    func getMovieList() {
        interactor
            .getMovieList()
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe({ [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .next(let moviesResult):
                        if let movies = moviesResult.value {
                            self.movieChangeRelay.accept(movies)
                        } else {
                            self.movieErrorChangeRelay.accept(ServiceError.badRequest)
                        }
                    case let .error(error):
                        self.movieErrorChangeRelay.accept(error)
                    case .completed:
                        break
                    }
                }
            ).disposed(by: disposeBag)
    }
    
    func getImage(forPath path: String, index: Int) {
        interactor
            .getImage(imagePath: path)
            .observeOn(MainScheduler.asyncInstance)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onSuccess: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(image):
                    self.imageChangeRelay.accept((index: index, image: image))
                default: break
                }
            }).disposed(by: disposeBag)
    }
    
}

// MARK: - MovieListOututInteractorProtocol

extension MovieListPresenter: MovieListOutputInteractorProtocol {
    
}
