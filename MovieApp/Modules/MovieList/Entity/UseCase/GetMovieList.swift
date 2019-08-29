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
}

class GetMovieListImpl: UseCaseImpl, GetMovieList {
    
    func execute(completion: @escaping UseCaseResponseClosure) {
        guard let repository = repository as? MovieRepository, repository.count > 0 else {
            fetchMoviesFromService(completion: completion)
            return
        }
        
        fetchMoviesFromCache { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                completion(.success(model: model))
            default:
                self.fetchMoviesFromService(completion: completion)
            }
        }
    }
    
    private func fetchMoviesFromService(completion: @escaping UseCaseResponseClosure) {
        guard let service = service as? MovieListService else {
            completion(.failure(error: UseCaseError.malformation))
            return
        }
        
        service.getMovieList { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .paginatedSuccess(let results):
                completion(.paginatedSuccess(results: results))
            case .success(let entity):
                completion(.success(model: entity))
                DispatchQueue.global().async {
                    self.saveMoviesInCahe(movies: entity)
                }
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    private func fetchMoviesFromCache(completion: @escaping UseCaseResponseClosure) {
        guard let repository = repository as? MovieRepository else {
            completion(.failure(error: UseCaseError.malformation))
            return
        }
        let movies = repository.fetchMovieList() ?? []
        
        if movies.isEmpty {
            completion(.failure(error: RepositoryError.noRecordsFound))
        } else {
            completion(.success(model: MovieListResponse(results: movies)))
        }
    }
    
    private func saveMoviesInCahe(movies: CodableEntity) {
        guard let repository = repository as? MovieRepository,
              let movies = (movies as? MovieListResponse)?.results  else {
            return
        }
        repository.saveMovies(movies: movies)
    }
    
}
