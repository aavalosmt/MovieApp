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
    
    override init(service: Service?, repository: Repository?) {
        self.apiState = ApiState(page: 0)
        super.init(service: service, repository: repository)
    }
    
    func reset() {
        self.apiState.reset()
    }
    
    func execute(completion: @escaping UseCaseResponseClosure) {
        self.apiState.increment()

        guard let repository = repository as? MovieRepository, repository.count(forPage: apiState.page) > 0 else {
            fetchMoviesFromService(page: apiState.page, completion: completion)
            return
        }
        
        fetchMoviesFromCache(page: apiState.page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                completion(.success(model: model))
            default:
                self.fetchMoviesFromService(page: self.apiState.page, completion: completion)
            }
        }
    }
    
    private func fetchMoviesFromService(page: Int, completion: @escaping UseCaseResponseClosure) {
        guard let service = service as? MovieListService else {
            completion(.failure(error: UseCaseError.malformation))
            return
        }
        
        service.getMovieList(page: page) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let entity):
                completion(.success(model: entity))
                DispatchQueue.global().async {
                    self.saveMoviesInCahe(page: page, movies: entity)
                }
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    private func fetchMoviesFromCache(page: Int, completion: @escaping UseCaseResponseClosure) {
        guard let repository = repository as? MovieRepository else {
            completion(.failure(error: UseCaseError.malformation))
            return
        }
        let movies = repository.fetchMovieList(forPage: page) ?? []
        
        if movies.isEmpty {
            completion(.failure(error: RepositoryError.noRecordsFound))
        } else {
            completion(.success(model: MovieListResponse(results: movies)))
        }
    }
    
    private func saveMoviesInCahe(page: Int, movies: CodableEntity) {
        guard let repository = repository as? MovieRepository,
              let movies = (movies as? MovieListResponse)?.results.compactMap({ movie -> (MovieEntity) in
                movie.page = page
                return movie
              }) else {
            return
        }
        
        repository.saveMovies(movies: movies)
    }
    
}
