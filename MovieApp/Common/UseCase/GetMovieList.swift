//
//  GetMovieList.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol GetMovieList {
    func execute(completion: @escaping UseCaseResponseClosure)
    func reset()
}

class GetMovieListImpl: UseCaseImpl, GetMovieList {
    
    private let apiState: ApiState
    private let type: MovieListType
    
    init(service: Service?, repository: Repository?, type: MovieListType) {
        self.apiState = ApiState(page: 0)
        self.type = type
        super.init(service: service, repository: repository)
    }
    
    func reset() {
        self.apiState.reset()
    }
    
    func execute(completion: @escaping UseCaseResponseClosure) {
        
        self.apiState.increment()
        
        guard let repository = repository as? MovieRepository, repository.count(forPage: apiState.page, type: type) > 0 else {
            fetchMoviesFromService(page: apiState.page, type: type, completion: completion)
            return
        }
        
        fetchMoviesFromCache(page: apiState.page, type: type) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                completion(.success(model: model))
            default:
                self.fetchMoviesFromService(page: self.apiState.page, type: self.type, completion: completion)
            }
        }
    }
    
    private func fetchMoviesFromService(page: Int, type: MovieListType, completion: @escaping UseCaseResponseClosure) {
        guard let service = service as? MovieListService else {
            completion(.failure(error: UseCaseError.malformation))
            return
        }
        
        service.getMovieList(page: page, type: type) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let entity):
                completion(.success(model: entity))
                DispatchQueue.global().async {
                    self.saveMoviesInCahe(page: page, type: type, movies: entity)
                }
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    private func fetchMoviesFromCache(page: Int, type: MovieListType,  completion: @escaping UseCaseResponseClosure) {
        guard let repository = repository as? MovieRepository else {
            completion(.failure(error: UseCaseError.malformation))
            return
        }
        
        let movies = repository.fetchMovieList(forPage: page, type: type) ?? []
        
        if movies.isEmpty {
            completion(.failure(error: RepositoryError.noRecordsFound))
        } else {
            completion(.success(model: MovieListResponse(results: movies)))
        }
    }
    
    private func saveMoviesInCahe(page: Int, type: MovieListType, movies: CodableEntity) {
        guard let repository = repository as? MovieRepository,
              let movies = (movies as? MovieListResponse)?.results.compactMap({ movie -> (MovieEntity) in
                var movie = movie
                movie.page = page
                if movie.listTypes == nil {
                    movie.listTypes = Set<MovieListType>()
                }
                movie.listTypes?.insert(type)
                return movie
              }) else {
            return
        }
        
        repository.saveMovies(movies: movies)
    }
    
}
