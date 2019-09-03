//
//  PopularPresenter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PopularPresenter: PopularPresenterProtocol {
    
    // MARK: - Outputs
    
    let moviesChanged: Signal<[Movie]>
    let imageChanged: Signal<(Int, UIImage?)>
    let error: Signal<Error>
    
    // MARK: - Inputs
    
    let reachedBottomTrigger: PublishSubject<Void> = PublishSubject<Void>()
    let viewDidLoadTrigger: PublishSubject<Void> = PublishSubject<Void>()
    let imageNeededTrigger: PublishSubject<(Int, String)> = PublishSubject<(Int, String)> ()
    
    // MARK: - Aux Relays
    
    private let errorChangeRelay: PublishRelay<Error> = PublishRelay<Error>()
    private let didMoviesChangeRelay: PublishRelay<[Movie]> = PublishRelay<[Movie]>()
    private let imageChangeRelay: PublishRelay<(Int, UIImage?)> = PublishRelay<(Int, UIImage?)>()
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    weak var view: PopularViewProtocol?
    var interactor: PopularInputInteractorProtocol
    var router: PopularRouterProtocol
    
    init(view: PopularViewProtocol,
         interactor: PopularInputInteractorProtocol,
         router: PopularRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.moviesChanged = didMoviesChangeRelay.asSignal()
        self.error = errorChangeRelay.asSignal()
        self.imageChanged = imageChangeRelay.asSignal()
        
        viewDidLoadTrigger
            .asSignal(onErrorJustReturn: ())
            .emit(onNext: { [weak self] text in
                guard let self = self else { return }
                self.getMovieList()
            }).disposed(by: disposeBag)
        
        imageNeededTrigger
            .asSignal(onErrorJustReturn: (-1, ""))
            .emit(onNext: { [weak self] (index, path) in
                guard let self = self else { return }
                self.getImage(forPath: path, index: index)
            }).disposed(by: disposeBag)
        
        reachedBottomTrigger.asObservable()
            .debounce(0.2, scheduler: SharingScheduler.make())
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                self.getMovieList()
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
                        self.didMoviesChangeRelay.accept(movies)
                    } else {
                        self.errorChangeRelay.accept(ServiceError.badRequest)
                    }
                case let .error(error):
                    self.errorChangeRelay.accept(error)
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

// MARK: - PopularOututInteractorProtocol

extension PopularPresenter: PopularOutputInteractorProtocol {
    
}
