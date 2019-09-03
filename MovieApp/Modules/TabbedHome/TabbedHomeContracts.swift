//
//  TabbedHomeContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol TabbedHomeRouterProtocol: class {
    static func createModule(subModules: [TabBarViewProtocol]) -> UIViewController
}

protocol TabbedHomePresenterProtocol: class {
    var view: TabbedHomeViewProtocol? { get }
    var interactor: TabbedHomeInputInteractorProtocol { get }
    var router: TabbedHomeRouterProtocol { get }
}

protocol TabbedHomeInputInteractorProtocol: class {
    var presenter: TabbedHomeOutputInteractorProtocol? { get set }
}

protocol TabbedHomeOutputInteractorProtocol: class {
    var interactor: TabbedHomeInputInteractorProtocol { get }
    var view: TabbedHomeViewProtocol? { get }
}
