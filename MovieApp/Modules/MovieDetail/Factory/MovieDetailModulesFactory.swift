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
    
    let moduleCreated: PublishSubject<MovieDetailModuleProtocol> = PublishSubject<MovieDetailModuleProtocol>()
    
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
        
        if let overView = movie.overView, !overView.isEmpty, let rating = movie.voteAverage, let releaseDate = movie.releaseDate, let title = movie.title  {
            moduleCreated.onNext(
                MovieDetailOverviewModule(
                    type: .overview,
                    title: title,
                    description: overView,
                    rating: rating,
                    releaseDate: releaseDate,
                    genres: movie.genres
                )
            )
        }
        
    }
    
}
