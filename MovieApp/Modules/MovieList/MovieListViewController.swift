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
    private var selectRowRelay: PublishRelay<Movie>

    init() {
        self.didLoadRelay = PublishRelay<Void>()
        self.imageNeededRelay = PublishRelay<(Int, String)>()
        self.selectRowRelay = PublishRelay<Movie>()
        super.init(nibName: String(describing: MovieListViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.didLoadRelay = PublishRelay<Void>()
        self.imageNeededRelay = PublishRelay<(Int, String)>()
        self.selectRowRelay = PublishRelay<Movie>()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToPresenter()
        configureTableView()

        presenter?.viewDidLoadTrigger.onNext(())
        
        tableView.rx.reachedBottom
            .bind(to: presenter!.reachedBottomTrigger)
            .disposed(by: disposeBag)
    }
    
    private func bindToPresenter() {
        
        presenter?.bind(
            imageNeededTrigger: imageNeededRelay.asSignal(),
            selectRowTrigger: selectRowRelay.asSignal())
        
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier) as? MovieTableViewCell,
              let movie = movies[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let posterPath = movies[safe: indexPath.row]?.posterPath {
            DispatchQueue.global().sync {
                imageNeededRelay.accept((indexPath.row, posterPath))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = movies[safe: indexPath.row] else {
            return
        }
        
        selectRowRelay.accept(movie)
    }
    
}
