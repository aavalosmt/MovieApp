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
    
    var modules: [PopularModule] = []
    var movies: [Movie] = []
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
                print(module.type)
                self.handleModuleEvent(module: module)
            default: return
            }
        }).disposed(by: disposeBag)
        
        presenter?
            .imageChanged
            .emit(onNext: { [weak self] (index, subIndex, image) in
                DispatchQueue.main.async {
                    self?.handleImage(index: index, subIndex: subIndex, image: image)
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
    
    private func handleImage(index: Int, subIndex: Int?, image: UIImage?) {
        guard index < modules.count else  {
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? UpcomingMovieTableViewCell {
                cell.movieImage.image = image
            }
            return
        }
        
        guard let module = modules[safe: index] else {
            return
        }
        
        switch module.type {
        case .starred:
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? StarredMovieTableViewCell {
                cell.movieImage.image = image
            }
            
        case .carousel:
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CarouselTableViewCell, let subIndex = subIndex {
                cell.carousel.didFetchImage(for: subIndex, image: image)
            }
            
        default:
            break
        }
    }
    
    private func handleModuleEvent(module: PopularModule) {
        var indexPaths: [IndexPath] = []
        
        if case let .list(movies) = module.type {
            let oldCount = self.movies.count + (self.modules.count - 1)
            let newCount = oldCount + movies.count
            
            for i in oldCount..<newCount {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
            
            guard !indexPaths.isEmpty else {
                return
            }
            DispatchQueue.global().async {
                DispatchQueue.main.sync {
                    self.movies.append(contentsOf: movies)
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                }
            }
        } else {
            let oldCount: Int = self.modules.count
            let newCount: Int = oldCount + 1
            
            
            for i in oldCount..<newCount {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
            
            if case .search = module.type {
                DispatchQueue.main.async {
                    self.modules.append(module)
                    self.tableView.reloadData()
                }
            } else {
                guard !indexPaths.isEmpty else {
                    return
                }
                DispatchQueue.global().async {
                    DispatchQueue.main.sync {
                        //                    self.tableView.beginUpdate
                        self.modules.append(module)
                        self.tableView.insertRows(at: indexPaths, with: .automatic)
                        
                    }
                }
            }
        }
    }
    
}

// MARK: - PopularViewProtocol

extension PopularViewController: PopularViewProtocol {
    
}

extension PopularViewController: CarouselDataSourceDelegate {
    
    func requestImage(forIndex index: Int) {
        guard let carouselIndex = modules.firstIndex(where: {
            if case .carousel = $0.type {
                return true
            }
            return false
        }) else {
            return
        }
        
        let carouselModule = modules[carouselIndex]
        
        if case let .carousel(movies) = carouselModule.type, let posterPath = movies[index].posterPath {
            DispatchQueue.global().sync {
                self.presenter?.imageNeededTrigger.onNext((carouselIndex, index, posterPath, .thumbnail))
            }
        }

    }
    
}
