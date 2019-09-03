//
//  PopularModulesFactory.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PopularModulesFactory {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    let movieTrigger: PublishSubject<[Movie]> = PublishSubject<[Movie]>()
    let genreTrigger: PublishSubject<[Genre]> = PublishSubject<[Genre]>()

    let moduleCreated: BehaviorSubject<PopularModule> = BehaviorSubject<PopularModule>(value: PopularModule(type: .search))
    
    var modules: Set<PopularModuleType> = Set<PopularModuleType>()
    
    init() {
        modules.insert(.search)
        
        movieTrigger.asObservable()
                .subscribe({ [weak self] event in
                    guard let self = self else { return }
                    guard let movies = event.element else {
                        return
                    }
                    self.handleMovies(movies: movies)
                }).disposed(by: disposeBag)
        
        genreTrigger.asObservable()
                .subscribe({ [weak self] event in
                    guard let self = self else { return }
                    self.handleGenres(event: event)
                }).disposed(by: disposeBag)
        
    }
    
    private func handleGenres(event: Event<[Genre]>) {
        guard let genres = event.element else {
            return
        }
        modules.insert(.genre(genres: []))
        moduleCreated.onNext(PopularModule(type: .genre(genres: genres)))
    }
    
    private func handleMovies(movies: [Movie]) {
        var movies = movies
    
        while !movies.isEmpty {
            
            guard let type = PopularModuleType.fromId(id: modules.count)?.withMovies(movies: movies) else {
                return
            }
            
            let results = sliceMovies(movies: &movies, type: type) ?? []
            
            switch type {
            case .starred:
                moduleCreated.onNext(PopularModule(type: .starred(movie: results.first)))
                modules.insert(.starred(movie: nil))
            case .carousel:
                moduleCreated.onNext(PopularModule(type: .carousel(movies: results)))
                modules.insert(.carousel(movies: []))
            case .list:
                moduleCreated.onNext(PopularModule(type: .list(movies: results)))
                modules.insert(.list(movies: []))
            default: return
            }
        }

        
    }
    
    private func sliceMovies(movies: inout [Movie], type: PopularModuleType) -> [Movie]? {
        var results: [Movie] = []
        let capacity: Int = type.capacity
        
        let top: Int = min(capacity, movies.count)
        
        if capacity < movies.count {
            results.append(contentsOf: movies[0..<top])
        }
        movies = Array(movies[top..<(movies.count)])
        
        return results
    }
    
}
