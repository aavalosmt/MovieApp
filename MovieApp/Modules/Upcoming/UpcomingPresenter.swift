//
//  UpcomingPresenter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UpcomingPresenter: UpcomingPresenterProtocol {
    
    // MARK: - Outputs
    
    let moviesChanged: Signal<[Movie]>
    let imageChanged: Signal<(Int, UIImage?)>
    let error: Signal<Error>

    // MARK: - Inputs
    
    let reachedBottomTrigger: PublishSubject<Void> = PublishSubject<Void>()
    let viewDidLoadTrigger: PublishSubject<Void> = PublishSubject<Void>()
    let imageNeededTrigger: PublishSubject<(Int, String)> = PublishSubject<(Int, String)> ()
    let selectRowTrigger: PublishSubject<Movie> = PublishSubject<Movie>()
    
    // MARK: - Aux Relays
    
    private let errorChangeRelay: PublishRelay<Error> = PublishRelay<Error>()
    private let didMoviesChangeRelay: PublishRelay<[Movie]> = PublishRelay<[Movie]>()
    private let imageChangeRelay: PublishRelay<(Int, UIImage?)> = PublishRelay<(Int, UIImage?)>()

    private let disposeBag: DisposeBag = DisposeBag()
    private var genres: [Genre] = []

    weak var view: UpcomingViewProtocol?
    var interactor: UpcomingInputInteractorProtocol
    var router: UpcomingRouterProtocol & UpcomingOutputRouterProtocol
    
    init(view: UpcomingViewProtocol,
         interactor: UpcomingInputInteractorProtocol,
         router: UpcomingRouterProtocol & UpcomingOutputRouterProtocol) {
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
                self.getGenres()
            }).disposed(by: disposeBag)
        
        imageNeededTrigger
            .asSignal(onErrorJustReturn: (-1, ""))
            .emit(onNext: { [weak self] (index, path) in
                guard let self = self else { return }
                self.getImage(forPath: path, index: index, size: .thumbnail)
            }).disposed(by: disposeBag)
        
        reachedBottomTrigger.asObservable()
            .debounce(0.2, scheduler: SharingScheduler.make())
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                self.getMovieList()
            }).disposed(by: disposeBag)
        
        selectRowTrigger
            .asSignal(
                onErrorJustReturn: MovieEntity()
            ).emit(onNext: { [weak self] movie in
                guard let self = self, let view = self.view as? Navigatable else { return }
                self.router.transitionDetail(from: view, movie: movie)
            }).disposed(by: disposeBag)
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
    
    func getImage(forPath path: String, index: Int, size: ImageSize) {
        interactor
            .getImage(imagePath: path, size: size)
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

// MARK: - UpcomingOututInteractorProtocol

extension UpcomingPresenter: UpcomingOutputInteractorProtocol {
    
}
