//
//  MovieDetailInteractor.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/30/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailInteractor: MovieDetailInputInteractorProtocol {
    
    weak var presenter: MovieDetailOutputInteractorProtocol?
   
    let disposeBag = DisposeBag()
    let imageProvider: ImageDownloader
    
    init(imageProvider: ImageDownloader) {
        self.imageProvider = imageProvider
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
    
}
