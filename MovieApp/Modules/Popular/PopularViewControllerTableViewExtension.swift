//
//  PopularViewControllerTableViewExtension.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

extension PopularViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        registerCells()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count + movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < modules.count else {
            guard let movie = movies[safe: (indexPath.row - modules.count)] else {
                return UITableViewCell()
            }
            return movieCell(tableView, movie: movie)
        }
        
        guard let module = modules[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        switch module.type {
        case .search:
            return searchCell(tableView)
        case .genre(let genres):
            return genreCell(tableView, genres: genres)
        case .starred(let movie):
            if let movie = movie {
                return starredCell(tableView, movie: movie)
            }
        case .carousel(let movies):
            return carouselCell(tableView, movies: movies)
        default: break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard indexPath.row < modules.count else {
            let index = indexPath.row - modules.count
            // Request movie image
            
            if let posterPath = movies[safe: index]?.posterPath {
                DispatchQueue.global().sync {
                    self.presenter?.imageNeededTrigger.onNext((indexPath.row, nil, posterPath, .thumbnail))
                }
            }
            return
        }
        
        guard let module = modules[safe: indexPath.row] else {
            return
        }
        
        switch module.type {
        case .starred(let movie):
            if let posterPath = movie?.posterPath {
                DispatchQueue.global().sync {
                    self.presenter?.imageNeededTrigger.onNext((indexPath.row, nil, posterPath, .full))
                }
            }
            
        default:
            break
        }
        
    }
    
    private func registerCells() {
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(identifier: SearchTableViewCell.identifier)
        tableView.register(identifier: GenreTableViewCell.identifier)
        tableView.register(identifier: StarredMovieTableViewCell.identifier)
        tableView.register(identifier: CarouselTableViewCell.identifier)
        tableView.register(identifier: UpcomingMovieTableViewCell.identifier)
    }
    
    private func searchCell(_ tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    private func genreCell(_ tableView: UITableView, genres: [Genre]) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GenreTableViewCell.identifier) as? GenreTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(withGenres: genres)
        return cell
    }
    
    private func starredCell(_ tableView: UITableView, movie: Movie) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StarredMovieTableViewCell.identifier) as? StarredMovieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(movie: movie)
        return cell
    }
    
    private func carouselCell(_ tableView: UITableView, movies: [Movie]) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarouselTableViewCell.identifier) as? CarouselTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configure(with: movies)
        return cell
    }
    
    private func movieCell(_ tableView: UITableView, movie: Movie) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMovieTableViewCell.identifier) as? UpcomingMovieTableViewCell else {
                return UITableViewCell()
        }
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let module = modules[safe: indexPath.row] else {
            return UITableView.automaticDimension
        }
        switch module.type {
        case .genre(let genres):
            let count: Int = genres.count / 2
            return ((tableView.frame.size.width / 4.0) + 30.0) * CGFloat(count)
        default:
            return UITableView.automaticDimension
        }
    }
}
