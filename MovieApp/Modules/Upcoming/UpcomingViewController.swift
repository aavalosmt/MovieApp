//
//  UpcomingViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol UpcomingViewProtocol: class {
    var presenter: UpcomingPresenterProtocol? { get set }
}

class UpcomingViewController: BasePagerViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    private weak var selectedImage: UIImageView?
    
    // MARK: - Variables
    
    private var movies: [Movie] = []
    
    override var tabTitle: String {
        return "UPCOMING_TITLE".localized
    }

    var presenter: UpcomingPresenterProtocol?
    
    // MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        configureTableView()
        bind()
        
    }
    
    // MARK: - Private methods
    
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
        
        if let presenter = presenter {
            tableView
                .rx
                .reachedBottom
                .bind(to: presenter.reachedBottomTrigger)
                .disposed(by: disposeBag)
        }
        
        presenter?.viewDidLoadTrigger.onNext(())
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.register(identifier: UpcomingMovieTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMovieTableViewCell.identifier) as? UpcomingMovieTableViewCell,
            let movie = movies[safe: indexPath.row] else {
                return UITableViewCell()
        }
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let posterPath = movies[safe: indexPath.row]?.posterPath {
            DispatchQueue.global().sync {
                self.presenter?.imageNeededTrigger.onNext((indexPath.row, posterPath))                    
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = movies[safe: indexPath.row], let cell = tableView.cellForRow(at: indexPath) as? UpcomingMovieTableViewCell else {
            return
        }
        
        selectedImage = cell.movieImage
        
        let transitionDependencies = TransitionDependencies(
            modalPresentationStyle: .custom,
            transitioningDelegate: self,
            sharingView: targetView)
        
        presenter?
            .selectRowTrigger
            .onNext((movie, transitionDependencies))
    }
}

// MARK: - UpcomingViewProtocol

extension UpcomingViewController: UpcomingViewProtocol {
    
}


extension UpcomingViewController: InterViewAnimatable, UIViewControllerTransitioningDelegate {
    
    var targetView: UIView? {
        return selectedImage
    }

    weak var snapshotImage: UIImage? {
        get {
            return selectedImage?.image
        }
        set(newValue) {
            selectedImage?.image = newValue
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = InterViewAnimation()
        animator.isPresenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = InterViewAnimation()
        animator.isPresenting = false
        return animator
    }
}
