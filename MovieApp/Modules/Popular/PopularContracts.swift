//
//  PopularContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol PopularRouterProtocol: class {
    static func createModule() -> UIViewController
}

protocol PopularPresenterProtocol: class {
    var view: PopularViewProtocol? { get }
    var interactor: PopularInputInteractorProtocol { get }
    var router: PopularRouterProtocol { get }
}

protocol PopularInputInteractorProtocol: class {
    var presenter: PopularOutputInteractorProtocol? { get set }
}

protocol PopularOutputInteractorProtocol: class {
    var interactor: PopularInputInteractorProtocol { get }
    var view: PopularViewProtocol? { get }
}
