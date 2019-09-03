//
//  UpcomingContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol UpcomingRouterProtocol: class {
    static func createModule() -> UIViewController
}

protocol UpcomingPresenterProtocol: class {
    var view: UpcomingViewProtocol? { get }
    var interactor: UpcomingInputInteractorProtocol { get }
    var router: UpcomingRouterProtocol { get }
}

protocol UpcomingInputInteractorProtocol: class {
    var presenter: UpcomingOutputInteractorProtocol? { get set }
}

protocol UpcomingOutputInteractorProtocol: class {
    var interactor: UpcomingInputInteractorProtocol { get }
    var view: UpcomingViewProtocol? { get }
}
