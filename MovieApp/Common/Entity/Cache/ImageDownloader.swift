//
//  ImageDownloader.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ImageDownloader {
    var cache: ImageCaching { get }
    var repository: Repository { get }
    var endpointProvider: EndpointProvider { get }
    
    func executeRequest(url: URL) -> Result<Any>
    func rxImage(imageUrl: String) -> Single<UIImage?>
}

enum ImageError: Error {
    case fetchingError
}

class ImageProvider: ImageDownloader {
    
    let repository: Repository
    
    let cache: ImageCaching
    let endpointProvider: EndpointProvider
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(cache: ImageCaching, endpointProvider: EndpointProvider = .shared, repository: Repository) {
        self.cache = cache
        self.endpointProvider = endpointProvider
        self.repository = repository
    }
    
    func executeRequest(url: URL) -> Result<Any> {
        return .success(Void.self)
    }
    
    func rxImage(imageUrl: String) -> Single<UIImage?> {
        return Single.create(subscribe: { [weak self] observer in
            guard let self = self else {
                observer(.error(ImageError.fetchingError))
                return Disposables.create()
            }
            
            let path = self.endpointProvider.thumbnailUrl(forEndpoint: .Image(path: imageUrl))
            guard let url = URL(string: path) else {
                observer(.error(ImageError.fetchingError))
                return Disposables.create()
            }
            
            if let image = self.cache.imageWithUrl(url: url) {
              
                observer(.success(image))
                
            } else if let image = (self.repository as? ImageRepository)?.search(key: imageUrl), let data = image.data, let uiimage = UIImage(data: data) {
                
                observer(.success(uiimage))
            } else {
                
                let urlRequest = URLRequest(url: url)
                URLSession.shared.rx
                    .response(request: urlRequest)
                    .subscribeOn(MainScheduler.instance)
                    .subscribe(onNext: { (response, data) in
                        let image = UIImage(data: data)
                        self.cache.saveImage(image: image, url: url)
                        self.saveImage(image: ImageEntity(data: data, key: imageUrl))
                        
                        observer(.success(image))
                    }, onError: { error in
                        observer(.error(error))
                    }).disposed(by: self.disposeBag)
            }
            
            return Disposables.create()
        })
    }
    
    private func saveImage(image: ImageEntity) {
        if let repository = self.repository as? ImageRepository {
            repository.saveImages(images: [image])
        }
    }

}
