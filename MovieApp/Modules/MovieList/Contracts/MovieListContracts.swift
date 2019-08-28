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

protocol MovieListPresenterProtocol: class {
    var didMovieListChange: Driver<[MovieEntity]> { get }
    var didMovieErrorChange: Signal<Error> { get }
    
    var view: MovieListViewProtocol? { get }
    var interactor: MovieListInputInteractorProtocol { get }
    var router: MovieListRouterProtocol { get }
    
    func bind(viewDidLoad: Signal<Void>)
    func getMovieList()
}

protocol MovieListInputInteractorProtocol: class {
    var presenter: MovieListOutputInteractorProtocol? { get set }
    var getMovieListUseCase: GetMovieList { get }
    
    func getMovieList() -> Single<Result<[MovieEntity]>>
}

protocol MovieListOutputInteractorProtocol: class {
    var interactor: MovieListInputInteractorProtocol { get }
    var view: MovieListViewProtocol? { get }
}
