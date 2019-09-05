//
//  SearchMovieInteractor.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/5/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchMovieInteractor: SearchMovieInputInteractorProtocol {

    let disposeBag = DisposeBag()
    let searchMovieUseCase: SearchMovie
    let getGenreListUseCase: GetGenreList
    let imageProvider: ImageDownloader

    weak var presenter: SearchMovieOutputInteractorProtocol?
    
    init(searchMovieUseCase: SearchMovie, getGenreListUseCase: GetGenreList, imageProvider: ImageDownloader) {
        self.searchMovieUseCase = searchMovieUseCase
        self.getGenreListUseCase = getGenreListUseCase
        self.imageProvider = imageProvider
    }
    
    func searchMovies(keyword: String) -> Observable<Result<[Movie]>> {
        return PublishRelay<Result<[Movie]>>.create({ [weak self] observer in
            guard let self = self else {
                observer.onError(UseCaseError.malformation)
                return Disposables.create()
            }
            
            let lock = NSRecursiveLock()
            self.searchMovieUseCase.execute(keyWord: keyword, completion: { response in
                switch response {
                case .success(let data):
                    guard let movieListResponse = data as? MovieListResponse else {
                        observer.onError(UseCaseError.malformation)
                        return
                    }
                    DispatchQueue.global(qos: .utility).async {
                        lock.lock()
                        observer.onNext(Result.success(movieListResponse.results))
                        lock.unlock()
                    }
                case .failure(let error):
                    observer.onError(error)
                    
                }
            })
            return Disposables.create()
        })
    }
    
    func getImage(imagePath: String, size: ImageSize) -> Single<Result<UIImage?>> {
        return Single.create(subscribe: { [weak self] observer in
            guard let self = self else {
                observer(.error(UseCaseError.malformation))
                return Disposables.create()
            }
            
            self.imageProvider.rxImage(imageUrl: imagePath, size: size)
                .subscribe(onSuccess: { image in
                    observer(.success(Result.success(image)))
                }, onError: { error in
                    observer(.error(error))
                    
                }
                ).disposed(by: self.disposeBag)
            
            return Disposables.create()
        })
    }
    
    func getGenreList() -> Single<Result<[Genre]>> {
        return Single.create(subscribe: { [weak self] observer in
            guard let self = self else {
                observer(.error(UseCaseError.malformation))
                return Disposables.create()
            }
            
            self.getGenreListUseCase.execute(completion: { result in
                switch result {
                case .success(let model):
                    guard let genres = (model as? GenreListResponse)?.genres else {
                        observer(.error(UseCaseError.malformation))
                        return
                    }
                    observer(.success(Result.success(genres)))
                case .failure(let error):
                    observer(.error(error))
                }
            })
            
            return Disposables.create()
        })
    }
}