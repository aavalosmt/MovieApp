//
//  LoaderContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoaderRouterProtocol: class {
    static func createModule() -> UIViewController
}

protocol LoaderPresenterProtocol: class {
    var view: LoaderViewProtocol? { get }
    var interactor: LoaderInputInteractorProtocol { get }
    var router: LoaderRouterProtocol { get }
    
    var didDataChange: Signal<Void> { get }
    var viewDidLoadTrigger: PublishSubject<Void> { get }
}

protocol LoaderInputInteractorProtocol: class {
    var presenter: LoaderOutputInteractorProtocol? { get set }
    
    func getGenreList() -> Observable<Result<[GenreEntity]>>
}

protocol LoaderOutputInteractorProtocol: class {
    var interactor: LoaderInputInteractorProtocol { get }
    var view: LoaderViewProtocol? { get }
}
