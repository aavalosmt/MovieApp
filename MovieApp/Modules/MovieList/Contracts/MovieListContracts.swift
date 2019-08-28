//
//  MovieListContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol MovieListRouterProtocol: class {
    static func createModule() -> UIViewController
}

protocol MovieListPresenterProtocol: class {
    var view: MovieListViewProtocol? { get }
    var interactor: MovieListInputInteractorProtocol { get }
    var router: MovieListRouterProtocol { get }
}

protocol MovieListInputInteractorProtocol: class {
    var presenter: MovieListOutputInteractorProtocol? { get set }
}

protocol MovieListOutputInteractorProtocol: class {
    var interactor: MovieListInputInteractorProtocol { get }
    var view: MovieListViewProtocol? { get }
}
