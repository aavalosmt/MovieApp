//
//  MovieDetailModulesFactory.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailModulesFactory {
    
    let moduleCreated: PublishSubject<MovieDetailModule> = PublishSubject<MovieDetailModule>()
    
    func getModules(for movie: Movie) {
        
        if let posterPath = movie.posterPath, !posterPath.isEmpty {
            moduleCreated.onNext(
                MovieDetailModule(
                    type: .poster(path: posterPath)
                )
            )
        }
        
        if let rating = movie.voteAverage {
            moduleCreated.onNext(
                MovieDetailModule(
                    type: .rating(rating: rating)
                )
            )
        }
        
        if let overView = movie.overView, !overView.isEmpty {
            moduleCreated.onNext(
                MovieDetailModule(
                    type: .overview(description: overView)
                )
            )
        }
        
    }
    
}
