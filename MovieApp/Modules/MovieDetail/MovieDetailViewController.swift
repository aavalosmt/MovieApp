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
    var headerView: UIImageView?
    weak var snapshotImage: UIImage?
    
    private var modules: [MovieDetailModule] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createHeaderView()
        configureTableView()
        bind()
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func createHeaderView() {
        guard headerView == nil else {
            return
        }
        
        headerView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 200.0))
        headerView?.contentMode = .scaleAspectFill
        headerView?.clipsToBounds = true
        headerView?.image = snapshotImage
    }
    
    private func bind() {
        presenter?
            .module
            .asObservable()
            .subscribe({ [weak self] event in
                guard let self = self else { return }
                switch event {
                case .next(let module):
                    DispatchQueue.main.async {
                        self.handleModule(module: module)
                    }
                default: return
                }
            }).disposed(by: disposeBag)
        
        presenter?
            .imageChanged
            .emit(onNext: { [weak self] (index, image) in
                DispatchQueue.main.async {
                    self?.headerView?.image = image
                }
            }).disposed(by: disposeBag)
        
        presenter?.viewDidLoadTrigger.onNext(())
    }
    
    private func handleModule(module: MovieDetailModule) {
        switch module.type {
        case .poster(let path):
            presenter?.imageNeededTrigger.onNext((-1, path, .full))
            return
            
        default: break
        }
        modules.append(module)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.tableHeaderView = headerView
        tableView.register(identifier: OverviewTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (modules.count > 0 ? (modules.count - 1) : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let module = modules[safe: indexPath.row + 1] else {
            return UITableViewCell()
        }
        
        switch module.type {
        case .overview(let description):
            return overviewCell(tableView, overview: description)
        default: break
        }
        
        return UITableViewCell()
    }
    
    private func overviewCell(_ tableView: UITableView, overview: String) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier) as? OverviewTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(overview: overview)
        return cell
    }
    
}

// MARK: - MovieDetailViewProtocol

extension MovieDetailViewController: MovieDetailViewProtocol {
    
}

extension MovieDetailViewController: InterViewAnimatable {
    
    var targetView: UIView? {
        return headerView
    }
    
}

