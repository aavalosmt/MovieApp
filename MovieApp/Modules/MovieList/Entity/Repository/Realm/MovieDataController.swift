//
//  MovieDataController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/29/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class MovieDataController: PersistanceController {
    
    var count: Int {
        return fetch()?.count ?? 0
    }
    
    let realmHandler: RealmHandler
    
    init(realmHandler: RealmHandler = .shared) {
        self.realmHandler = realmHandler
    }
    
    func save(objects: [Any]) {
        guard let movies = objects as? [MovieEntity] else {
            return
        }
        
        let realmMovies = movies.compactMap({ (movie) -> RealmMovie in
            let realmMovie: RealmMovie = RealmMovie()
            
            realmMovie.originalTitle = movie.originalTitle
            realmMovie.title = movie.title
            realmMovie.voteCount = movie.voteCount
            realmMovie.voteAverage = movie.voteAverage
            realmMovie.popularity = movie.popularity
            realmMovie.hasVideo = movie.hasVideo
            realmMovie.mediaType = movie.mediaType
            realmMovie.releaseDate = movie.releaseDate
            realmMovie.originalLanguage = movie.originalLanguage
            realmMovie.overView = movie.overView
            realmMovie.isAdultRated = movie.isAdultRated
            realmMovie.genreIds = movie.genreIds
            realmMovie.posterPath = movie.posterPath
            
            return realmMovie
        })
        
        realmHandler.addObjects(objects: realmMovies, update: .all)
    }
    
    func fetch() -> [Any]? {
        let objects = realmHandler.getObjects(type: RealmMovie.self)
        
        let movies = objects?.compactMap({ (realmMovie) -> MovieEntity? in
            guard let realmMovie = realmMovie as? RealmMovie else {
                return nil
            }
            
            let entity = MovieEntity(originalTitle: realmMovie.originalTitle,
                                     title: realmMovie.title,
                                     voteCount: realmMovie.voteCount,
                                     voteAverage: realmMovie.voteAverage,
                                     popularity: realmMovie.popularity,
                                     hasVideo: realmMovie.hasVideo,
                                     mediaType: realmMovie.mediaType,
                                     releaseDate: realmMovie.releaseDate,
                                     originalLanguage: realmMovie.originalLanguage,
                                     overView: realmMovie.overView,
                                     isAdultRated: realmMovie.isAdultRated,
                                     genreIds: realmMovie.genreIds,
                                     posterPath: realmMovie.posterPath)
            
            return entity
        })
        
        return (movies?.isEmpty ?? true) ? nil : movies
    }
    
    func search(key: Any) -> Any? {
        guard let key = key as? String else {
            return nil
        }
        
        guard let realmMovie = realmHandler.getObject(type: RealmMovie.self, forKey: key) as? RealmMovie else {
            return nil
        }
        
        return MovieEntity(originalTitle: realmMovie.originalTitle,
                           title: realmMovie.title,
                           voteCount: realmMovie.voteCount,
                           voteAverage: realmMovie.voteAverage,
                           popularity: realmMovie.popularity,
                           hasVideo: realmMovie.hasVideo,
                           mediaType: realmMovie.mediaType,
                           releaseDate: realmMovie.releaseDate,
                           originalLanguage: realmMovie.originalLanguage,
                           overView: realmMovie.overView,
                           isAdultRated: realmMovie.isAdultRated,
                           genreIds: realmMovie.genreIds,
                           posterPath: realmMovie.posterPath)
    }
    
}