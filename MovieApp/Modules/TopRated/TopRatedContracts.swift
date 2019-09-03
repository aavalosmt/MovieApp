//
//  TopRatedContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol TopRatedRouterProtocol: class {
    static func createModule() -> UIViewController
}

protocol TopRatedPresenterProtocol: class {
    var view: TopRatedViewProtocol? { get }
    var interactor: TopRatedInputInteractorProtocol { get }
    var router: TopRatedRouterProtocol { get }
}

protocol TopRatedInputInteractorProtocol: class {
    var presenter: TopRatedOutputInteractorProtocol? { get set }
}

protocol TopRatedOutputInteractorProtocol: class {
    var interactor: TopRatedInputInteractorProtocol { get }
    var view: TopRatedViewProtocol? { get }
}
