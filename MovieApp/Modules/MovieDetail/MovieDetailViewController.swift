//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/30/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol MovieDetailViewProtocol: class {
    var presenter: MovieDetailPresenterProtocol? { get set }
}

class MovieDetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: MovieDetailPresenterProtocol?
    var headerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createHeaderView()
        
        bind()
    }
    
    private func createHeaderView() {
        guard headerView == nil else {
            return
        }
        
        headerView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200.0))
    }
    
    private func bind() {
        presenter?
            .module
            .asObservable()
            .subscribe({ [weak self] event in
                guard let self = self else { return }
                switch event {
                case .next(let module):
                    print(module.type)
                default: return
                }
            }).disposed(by: disposeBag)
        
        presenter?.viewDidLoadTrigger.onNext(())
    }
    
}

// MARK: - MovieDetailViewProtocol

extension MovieDetailViewController: MovieDetailViewProtocol {
    
}
