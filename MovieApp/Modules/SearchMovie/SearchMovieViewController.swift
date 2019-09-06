//
//  SearchMovieViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/5/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol SearchMovieViewProtocol: class {
    var presenter: SearchMoviePresenterProtocol? { get set }
}

class SearchMovieViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: AppTitleLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchButton: AppFilledButton!
    
    private var movies: [Movie] = []
    
    var presenter: SearchMoviePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind()
    }
    
    private func configureUI() {
       titleLabel.text = "SEARCH".localized
        searchTextfield.layer.cornerRadius = 15.0
        searchTextfield.clipsToBounds = true
        
        searchTextfield.leftViewMode = .always
        searchTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40.0, height: 0.0))
        
        searchButton.layer.cornerRadius = searchButton.frame.size.width / 2.0
        
        configureTableView()
    }
    
    private func bind() {
        presenter?
            .moviesChanged
            .emit(onNext: { [weak self] results in
                guard let self = self else { return }
                let oldCount = self.movies.count
                self.movies.append(contentsOf: results)
                
                var indexPaths: [IndexPath] = []
                
                for i in oldCount..<self.movies.count {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                
                DispatchQueue.main.async {
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                }
            }).disposed(by: disposeBag)
        
        presenter?
            .imageChanged
            .emit(onNext: { [weak self] (index, image) in
                DispatchQueue.main.async {
                    if let cell = self?.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? UpcomingMovieTableViewCell {
                        cell.movieImage.image = image
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSearch(_ sender: Any) {
        movies.removeAll()
        presenter?.searchMovieTrigger.onNext(searchTextfield.text ?? "")
    }
    
}

// MARK: - SearchMovieViewProtocol

extension SearchMovieViewController: SearchMovieViewProtocol {
    
}

extension SearchMovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.register(identifier: UpcomingMovieTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMovieTableViewCell.identifier) as? UpcomingMovieTableViewCell,
            let movie = movies[safe: indexPath.row] else {
                return UITableViewCell()
        }
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let posterPath = movies[safe: indexPath.row]?.posterPath {
            DispatchQueue.global().sync {
                self.presenter?.imageNeededTrigger.onNext((indexPath.row, posterPath))
            }
        }
    }
}
