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
    let imageChanged: Signal<(Int, Int?, UIImage?)>
    let error: Signal<Error>
    let module: Driver<PopularModule>
    
    // MARK: - Inputs
    
    let reachedBottomTrigger: PublishSubject<Void> = PublishSubject<Void>()
    let viewDidLoadTrigger: PublishSubject<Void> = PublishSubject<Void>()
    let imageNeededTrigger: PublishSubject<(Int, Int?, String, ImageSize)> = PublishSubject<(Int, Int?, String, ImageSize)> ()
    
    // MARK: - Aux Relays
    
    private let moduleChangeRelay: BehaviorRelay<PopularModule> = BehaviorRelay<PopularModule>(value: PopularModule(type: .search))
    private let errorChangeRelay: PublishRelay<Error> = PublishRelay<Error>()
    private let didMoviesChangeRelay: PublishRelay<[Movie]> = PublishRelay<[Movie]>()
    private let imageChangeRelay: PublishRelay<(Int, Int?, UIImage?)> = PublishRelay<(Int, Int?, UIImage?)>()
    private var genres: [Genre] = []
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    weak var view: PopularViewProtocol?
    var interactor: PopularInputInteractorProtocol
    var router: PopularRouterProtocol
    private let factory: PopularModulesFactory
    
    init(view: PopularViewProtocol,
         interactor: PopularInputInteractorProtocol,
         router: PopularRouterProtocol,
         factory: PopularModulesFactory) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.factory = factory
        
        self.moviesChanged = didMoviesChangeRelay.asSignal()
        self.error = errorChangeRelay.asSignal()
        self.imageChanged = imageChangeRelay.asSignal()
        self.module = moduleChangeRelay.asDriver()
        
        viewDidLoadTrigger
            .asSignal(onErrorJustReturn: ())
            .emit(onNext: { [weak self] text in
                guard let self = self else { return }
                self.getGenres()
            }).disposed(by: disposeBag)
        
        imageNeededTrigger
            .asSignal(onErrorJustReturn: (-1, nil, "", .thumbnail))
            .emit(onNext: { [weak self] (index, subIndex, path, size) in
                guard let self = self else { return }
                self.getImage(forPath: path, subIndex: subIndex, index: index, size: size)
            }).disposed(by: disposeBag)
        
        reachedBottomTrigger
            .asObservable()
            .debounce(0.2, scheduler: SharingScheduler.make())
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                self.getMovieList()
            }).disposed(by: disposeBag)
        
        self.factory.moduleCreated
                    .asObservable()
                    .bind(to: moduleChangeRelay)
                    .disposed(by: disposeBag)
    }
    
    private func getGenres() {
        interactor
            .getGenreList()
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe({ [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let genreResponse):
                    guard let genres = genreResponse.value else {
                        self.errorChangeRelay.accept(UseCaseError.malformation)
                        return
                    }
                    self.genres = genres
                    self.getMovieList()
                case .error(let error):
                    self.errorChangeRelay.accept(error)
                }
                
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
                    if let movies = moviesResult.value?.compactMap({ (movie) -> MovieEntity? in
                        guard var movie = movie as? MovieEntity else {
                            return nil
                        }
                        self.addGenres(toMovie: &movie)
                        return movie
                    }) {
                        self.factory.movieTrigger.onNext(movies)
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
    
    func getImage(forPath path: String, subIndex: Int?, index: Int, size: ImageSize) {
        interactor
            .getImage(imagePath: path, size: size)
            .observeOn(MainScheduler.asyncInstance)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onSuccess: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(image):
                    self.imageChangeRelay.accept((index: index, subIndex: subIndex, image: image))
                default: break
                }
            }).disposed(by: disposeBag)
    }
    
    private func addGenres(toMovie movie: inout MovieEntity) {
        guard let genreIds = movie.genreIds else {
            return
        }
        
        for genreId in genreIds {
            if let genreName = genres.first(where: { $0.id == genreId })?.name {
                movie.genres.append(genreName)
            }
        }
    }
    
}

// MARK: - PopularOututInteractorProtocol

extension PopularPresenter: PopularOutputInteractorProtocol {
    
}
