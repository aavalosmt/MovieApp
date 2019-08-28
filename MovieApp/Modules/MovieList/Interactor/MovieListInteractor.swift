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
    
    weak var presenter: MovieListOutputInteractorProtocol?
    
    init(getMovieListUseCase: GetMovieList) {
        self.getMovieListUseCase = getMovieListUseCase
    }
    
    func getMovieList() -> Single<Result<[MovieEntity]>> {
        return Single.create(subscribe: { [weak self] observer in
            guard let self = self else {
                observer(.error(UseCaseError.malformation))
                return Disposables.create()
            }
            
            self.getMovieListUseCase.execute(completion: { response in
                switch response {
                case .paginatedSuccess(let results):
                    guard let movieListResponse = results as? [MovieListResponse] else {
                        observer(.error(UseCaseError.malformation))
                        return
                    }
                    
                    let movies = movieListResponse.compactMap({ $0.results }).flatMap({ $0 })
                    observer(
                        .success(
                            Result.success(
                                movies
                            )
                        )
                    )

                case .success(let data):
                    guard let movieListResponse = data as? MovieListResponse else {
                        observer(.error(UseCaseError.malformation))
                        return
                    }
                    
                    observer(.success(Result.success(movieListResponse.results)))
                case .failure(let error):
                    observer(.error(error))
                }
            })
            return Disposables.create()
        })
    }
    
}
