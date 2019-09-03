//
//  LoaderInteractor.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoaderInteractor: LoaderInputInteractorProtocol {
    
    weak var presenter: LoaderOutputInteractorProtocol?
    
    let getGenreListUseCase: GetGenreList
    
    init(getGenreListUseCase: GetGenreList) {
        self.getGenreListUseCase = getGenreListUseCase
    }
    
    func getGenreList() -> Observable<Result<[GenreEntity]>> {
        return PublishRelay<Result<[GenreEntity]>>.create({ [weak self] observer in
            guard let self = self else {
                observer.onError(UseCaseError.malformation)
                return Disposables.create()
            }
            
            self.getGenreListUseCase.execute(completion: { response in
                switch response {
                case .success(let data):
                    guard let genreListResponse = data as? GenreListResponse else {
                        observer.onError(UseCaseError.malformation)
                        return
                    }
                    
                    observer.onNext(Result.success(genreListResponse.genres))
                    
                case .failure(let error):
                    observer.onError(error)

                }
            })

            return Disposables.create()
        })
    }
    
}
