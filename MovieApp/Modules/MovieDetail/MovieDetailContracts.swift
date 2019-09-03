//
//  MovieDetailContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/30/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol MovieDetailRouterProtocol: class {
    static func createModule(movie: Movie) -> UIViewController
}

protocol MovieDetailPresenterProtocol: class {
    var view: MovieDetailViewProtocol? { get }
    var interactor: MovieDetailInputInteractorProtocol { get }
    var router: MovieDetailRouterProtocol { get }
    
    var movie: Movie { get }
}

protocol MovieDetailInputInteractorProtocol: class {
    var presenter: MovieDetailOutputInteractorProtocol? { get set }
}

protocol MovieDetailOutputInteractorProtocol: class {
    var interactor: MovieDetailInputInteractorProtocol { get }
    var view: MovieDetailViewProtocol? { get }
}
