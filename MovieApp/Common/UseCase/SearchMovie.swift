//
//  SearchMovie.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/5/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol SearchMovie {
    func execute(keyWord: String, completion: @escaping UseCaseResponseClosure)
}

class SearchMovieImpl: UseCaseImpl, SearchMovie {
    
    private let apiState: ApiState
    private let reachability: ReachabilityProtocol
    
    init(service: Service? = nil, repository: Repository? = nil, reachability: ReachabilityProtocol = Reachability.shared) {
        self.apiState = ApiState(page: 0)
        self.reachability = reachability
        super.init(service: service, repository: repository)
    }
    
    func reset() {
        self.apiState.reset()
    }
    
    func execute(keyWord: String, completion: @escaping UseCaseResponseClosure) {
        
        if reachability.isReachable {
            fetchMoviesFromService(keyword: keyWord, completion: completion)
        } else {
            fetchMoviesFromCache(keyword: keyWord, completion: completion)
        }
    }
    
    private func fetchMoviesFromService(keyword: String, completion: @escaping UseCaseResponseClosure) {
        guard let service = service as? SearchMovieService else {
            completion(.failure(error: UseCaseError.malformation))
            return
        }
        
        service.searchMovies(withKeyword: keyword, completion: { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let entity):
                completion(.success(model: entity))
                DispatchQueue.global().async {
                    self.saveMoviesInCahe(movies: entity)
                }
            case .failure(let error):
                completion(.failure(error: error))
            }
        })
    }
    
    private func fetchMoviesFromCache(keyword: String, completion: @escaping UseCaseResponseClosure) {
        guard let repository = repository as? MovieRepository else {
            completion(.failure(error: UseCaseError.malformation))
            return
        }
        
        let movies = repository.searchMovies(keyword: keyword) ?? []
        
        if movies.isEmpty {
            completion(.failure(error: RepositoryError.noRecordsFound))
        } else {
            completion(.success(model: MovieListResponse(results: movies)))
        }
    }
    
    private func saveMoviesInCahe(movies: CodableEntity) {
        guard let repository = repository as? MovieRepository,
            let movies = (movies as? MovieListResponse)?.results.compactMap({ movie -> (MovieEntity) in
                var movie = movie
                
                if movie.listTypes == nil {
                    movie.listTypes = Set<MovieListType>()
                }
                movie.listTypes?.insert(.search)
                return movie
            }) else {
                return
        }
        
        repository.saveMovies(movies: movies)
    }
    
}
