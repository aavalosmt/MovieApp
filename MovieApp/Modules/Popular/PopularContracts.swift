//
//  PopularContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PopularRouterProtocol: class {
    static func createModule() -> UIViewController
}

protocol PopularPresenterProtocol: class {
    var view: PopularViewProtocol? { get }
    var interactor: PopularInputInteractorProtocol { get }
    var router: PopularRouterProtocol { get }
    
    var moviesChanged: Signal<[Movie]> { get }
    var imageChanged: Signal<(Int, Int?, UIImage?)> { get }
    var error: Signal<Error> { get }
    
    var reachedBottomTrigger: PublishSubject<Void> { get }
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var imageNeededTrigger: PublishSubject<(Int, Int?, String, ImageSize)> { get }
    var module: Driver<PopularModule> { get }
}

protocol PopularInputInteractorProtocol: class {
    var presenter: PopularOutputInteractorProtocol? { get set }
    
    func getMovieList() -> Observable<Result<[Movie]>>
    func getImage(imagePath: String, size: ImageSize) -> Single<Result<UIImage?>>
    func getGenreList() -> Single<Result<[Genre]>>
}

protocol PopularOutputInteractorProtocol: class {
    var interactor: PopularInputInteractorProtocol { get }
    var view: PopularViewProtocol? { get }
}
