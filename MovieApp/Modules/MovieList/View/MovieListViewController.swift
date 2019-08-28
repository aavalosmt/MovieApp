//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MovieListViewProtocol: class {
    var presenter: MovieListPresenterProtocol? { get set }
}

class MovieListViewController: BaseViewController {

    var presenter: MovieListPresenterProtocol?
    
    private var didLoadRelay: PublishRelay<Void>
    
    init() {
        self.didLoadRelay = PublishRelay<Void>()
        super.init(nibName: String(describing: MovieListViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.didLoadRelay = PublishRelay<Void>()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToPresenter()
        didLoadRelay.accept(())
    }
    
    private func bindToPresenter() {
        
        presenter?.bind(viewDidLoad: didLoadRelay.asSignal())
    }
    
}

// MARK: - MovieListViewProtocol

extension MovieListViewController: MovieListViewProtocol {
    
}
