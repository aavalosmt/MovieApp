//
//  MovieListContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MovieListRouterProtocol: class {
    static func createModule() -> UIViewController
}

protocol MovieListRouterOutputProtocol: class {
    func transitionDetail(from: Navigatable, movie: Movie)
}

protocol MovieListPresenterProtocol: class {
    var didMovieListChange: Driver<[MovieEntity]> { get }
    var didMovieErrorChange: Signal<Error> { get }
    var didImageChange: Driver<(index: Int, image: UIImage?)> { get }
    var reachedBottomTrigger: PublishSubject<Void> { get }
    var viewDidLoadTrigger: PublishSubject<Void> { get }

    var view: MovieListViewProtocol? { get }
    var interactor: MovieListInputInteractorProtocol { get }
    var router: MovieListRouterProtocol & MovieListRouterOutputProtocol { get }
    
    func bind(imageNeededTrigger: Signal<(Int, String)>, selectRowTrigger: Signal<Movie>)
    func getMovieList()
}

protocol MovieListInputInteractorProtocol: class {
    var presenter: MovieListOutputInteractorProtocol? { get set }
    var getMovieListUseCase: GetMovieList { get }
    var imageProvider: ImageDownloader { get }
    
    func getMovieList() -> Observable<Result<[MovieEntity]>>
    func getImage(imagePath: String) -> Single<Result<UIImage?>>
}

protocol MovieListOutputInteractorProtocol: class {
    var interactor: MovieListInputInteractorProtocol { get }
    var view: MovieListViewProtocol? { get }
}
