//
//  MovieListInteractor.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListInteractor: MovieListInputInteractorProtocol {
    
    let disposeBag = DisposeBag()
    let getMovieListUseCase: GetMovieList
    let imageProvider: ImageDownloader
    
    weak var presenter: MovieListOutputInteractorProtocol?
    
    init(getMovieListUseCase: GetMovieList, imageProvider: ImageDownloader) {
        self.getMovieListUseCase = getMovieListUseCase
        self.imageProvider = imageProvider
    }
    
    func getMovieList() -> Observable<Result<[MovieEntity]>> {
        return PublishRelay<Result<[MovieEntity]>>.create({ [weak self] observer in
            guard let self = self else {
                observer.onError(UseCaseError.malformation)
                return Disposables.create()
            }
            
            let lock = NSRecursiveLock()
            self.getMovieListUseCase.execute(completion: { response in
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
    
    func getImage(imagePath: String) -> Single<Result<UIImage?>> {
        return Single.create(subscribe: { [weak self] observer in
            guard let self = self else {
                observer(.error(UseCaseError.malformation))
                return Disposables.create()
            }
    
            self.imageProvider.rxImage(imageUrl: imagePath)
                .subscribe(onSuccess: { image in
                    observer(.success(Result.success(image)))
                }, onError: { error in
                    observer(.error(error))

                }
            ).disposed(by: self.disposeBag)
            
            return Disposables.create()
        })
    }
}
