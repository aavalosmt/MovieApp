//
//  UpcomingContracts.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol UpcomingRouterProtocol: class {
    static func createModule() -> UIViewController
}

protocol UpcomingPresenterProtocol: class {
    var view: UpcomingViewProtocol? { get }
    var interactor: UpcomingInputInteractorProtocol { get }
    var router: UpcomingRouterProtocol & UpcomingOutputRouterProtocol { get }
    
    var moviesChanged: Signal<[Movie]> { get }
    var imageChanged: Signal<(Int, UIImage?)> { get }
    var error: Signal<Error> { get }
    
    var reachedBottomTrigger: PublishSubject<Void> { get }
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var imageNeededTrigger: PublishSubject<(Int, String)> { get }
    var selectRowTrigger: PublishSubject<(Movie, TransitionDependencies)> { get }

}

protocol UpcomingInputInteractorProtocol: class {
    var presenter: UpcomingOutputInteractorProtocol? { get set }
    
    func getMovieList() -> Observable<Result<[Movie]>>
    func getImage(imagePath: String, size: ImageSize) -> Single<Result<UIImage?>>
    func getGenreList() -> Single<Result<[Genre]>>
}

protocol UpcomingOutputInteractorProtocol: class {
    var interactor: UpcomingInputInteractorProtocol { get }
    var view: UpcomingViewProtocol? { get }
}
