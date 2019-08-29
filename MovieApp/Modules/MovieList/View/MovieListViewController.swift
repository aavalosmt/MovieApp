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

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: MovieListPresenterProtocol?
    private var movies: [MovieEntity] = []
    
    private var didLoadRelay: PublishRelay<Void>
    private var imageNeededRelay: PublishRelay<(Int, String)>
    
    init() {
        self.didLoadRelay = PublishRelay<Void>()
        self.imageNeededRelay = PublishRelay<(Int, String)>()
        super.init(nibName: String(describing: MovieListViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.didLoadRelay = PublishRelay<Void>()
        self.imageNeededRelay = PublishRelay<(Int, String)>()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToPresenter()
        configureTableView()
        didLoadRelay.accept(())
    }
    
    private func bindToPresenter() {
        
        presenter?.bind(viewDidLoad: didLoadRelay.asSignal(), imageNeeded: imageNeededRelay.asSignal())
        
        presenter?.didMovieListChange.drive(onNext: { [weak self] results in
            self?.movies.append(contentsOf: results)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        presenter?.didImageChange.drive(onNext: { [weak self] (index, image) in
            DispatchQueue.main.async {
                if let cell = self?.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MovieTableViewCell {
                    cell.movieImage.image = image
                }
            }
        }).disposed(by: disposeBag)
    }
    
}

// MARK: - MovieListViewProtocol

extension MovieListViewController: MovieListViewProtocol {
    
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        tableView.register(identifier: MovieTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let index = indexPath.row
        let movie = movies[index]
        
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let movie = movies[index]
        
        if let posterPath = movie.posterPath {
            DispatchQueue.global().sync {
                imageNeededRelay.accept((index, posterPath))
            }
        }
    }
    
}
