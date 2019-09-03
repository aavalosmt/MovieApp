//
//  LoaderPresenter.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoaderPresenter: LoaderPresenterProtocol {
    
    let didDataChange: Signal<Void>
    let viewDidLoadTrigger: PublishSubject<Void> = PublishSubject<Void>()
    
    private let didDataChangeRelay: PublishRelay<Void> = PublishRelay<Void>()
    private let disposeBag: DisposeBag = DisposeBag()

    weak var view: LoaderViewProtocol?
    var interactor: LoaderInputInteractorProtocol
    var router: LoaderRouterProtocol
    
    init(view: LoaderViewProtocol,
         interactor: LoaderInputInteractorProtocol,
         router: LoaderRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.didDataChange = didDataChangeRelay.asSignal()
        
        viewDidLoadTrigger.asSignal(onErrorJustReturn: ())
            .emit(onNext: { [weak self] text in
                guard let self = self else { return }
                self.loadData()
            }
        ).disposed(by: disposeBag)
    }
    
    func loadData() {
        interactor
            .getGenreList()
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe({ [weak self] result in
                guard let self = self else { return }
                self.didDataChangeRelay.accept(())
            }).disposed(by: disposeBag)
    }
    
}

// MARK: - LoaderOututInteractorProtocol

extension LoaderPresenter: LoaderOutputInteractorProtocol {
    
}
