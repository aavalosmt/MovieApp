//
//  PopularViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol PopularViewProtocol: class {
    var presenter: PopularPresenterProtocol? { get set }
}

class PopularViewController: BasePagerViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override var tabTitle: String {
        return "POPULAR_TITLE".localized
    }
    
    private var modules: [PopularModule] = []
    var presenter: PopularPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bind()
    }
    
    private func bind() {
        presenter?.module.asObservable().subscribe({ [weak self] event in
            guard let self = self else { return }
            switch event {
            case .next(let module):
                self.modules.append(module)
            default: return
            }
        }).disposed(by: disposeBag)
        
        presenter?.viewDidLoadTrigger.onNext(())
    }
    
}

extension PopularViewController: UITableViewDelegate, UITableViewDataSource {

    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}

// MARK: - PopularViewProtocol

extension PopularViewController: PopularViewProtocol {
    
}
