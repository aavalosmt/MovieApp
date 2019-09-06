//
//  MovieDetailContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/30/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MovieDetailRouterProtocol: class {
    static func createModule(movie: Movie) -> UIViewController
}

protocol MovieDetailPresenterProtocol: class {
    var view: MovieDetailViewProtocol? { get }
    var interactor: MovieDetailInputInteractorProtocol { get }
    var router: MovieDetailRouterProtocol { get }
    
    var movie: Movie { get }
    
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var imageNeededTrigger: PublishSubject<(Int, String, ImageSize)> { get }
    
    var imageChanged: Signal<(Int, UIImage?)> { get }
    var module: Signal<MovieDetailModuleProtocol> { get }
}

protocol MovieDetailInputInteractorProtocol: class {
    var presenter: MovieDetailOutputInteractorProtocol? { get set }
    
    func getImage(imagePath: String, size: ImageSize) -> Single<Result<UIImage?>>
}

protocol MovieDetailOutputInteractorProtocol: class {
    var interactor: MovieDetailInputInteractorProtocol { get }
    var view: MovieDetailViewProtocol? { get }
}
