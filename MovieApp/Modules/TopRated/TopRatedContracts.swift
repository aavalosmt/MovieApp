//
//  TopRatedContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol TopRatedRouterProtocol: class {
    static func createModule() -> UIViewController
}

protocol TopRatedPresenterProtocol: class {
    var view: TopRatedViewProtocol? { get }
    var interactor: TopRatedInputInteractorProtocol { get }
    var router: TopRatedRouterProtocol { get }
    
    var moviesChanged: Signal<[Movie]> { get }
    var imageChanged: Signal<(Int, UIImage?)> { get }
    var error: Signal<Error> { get }
    
    var reachedBottomTrigger: PublishSubject<Void> { get }
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var imageNeededTrigger: PublishSubject<(Int, String)> { get }
    
}

protocol TopRatedInputInteractorProtocol: class {
    var presenter: TopRatedOutputInteractorProtocol? { get set }
    
    func getMovieList() -> Observable<Result<[Movie]>>
    func getImage(imagePath: String) -> Single<Result<UIImage?>>
}

protocol TopRatedOutputInteractorProtocol: class {
    var interactor: TopRatedInputInteractorProtocol { get }
    var view: TopRatedViewProtocol? { get }
}
