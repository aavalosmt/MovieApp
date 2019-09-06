//
//  SearchMovieContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/5/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchMovieRouterProtocol: class {
    static func createModule() -> UIViewController
}

protocol SearchMoviePresenterProtocol: class {
    var view: SearchMovieViewProtocol? { get }
    var interactor: SearchMovieInputInteractorProtocol { get }
    var router: SearchMovieRouterProtocol { get }
    
    var searchMovieTrigger: PublishSubject<String> { get }
    var imageNeededTrigger: PublishSubject<(Int, String)> { get }

    var moviesChanged: Signal<[Movie]> { get }
    var imageChanged: Signal<(Int, UIImage?)> { get }
    var error: Signal<Error> { get }
}

protocol SearchMovieInputInteractorProtocol: class {
    var presenter: SearchMovieOutputInteractorProtocol? { get set }
    
    var searchMovieUseCase: SearchMovie { get }
    var getGenreListUseCase: GetGenreList { get }
    var imageProvider: ImageDownloader { get }
    
    func searchMovies(keyword: String) -> Observable<Result<[Movie]>>
    func getImage(imagePath: String, size: ImageSize) -> Single<Result<UIImage?>>
    func getGenreList() -> Single<Result<[Genre]>>
}

protocol SearchMovieOutputInteractorProtocol: class {
    var interactor: SearchMovieInputInteractorProtocol { get }
    var view: SearchMovieViewProtocol? { get }
}
