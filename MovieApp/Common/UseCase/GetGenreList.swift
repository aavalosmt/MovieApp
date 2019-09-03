//
//  GetGenreList.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol GetGenreList {
    func execute(completion: @escaping UseCaseResponseClosure)
}

class GetGenreListImpl: UseCaseImpl, GetGenreList {
    
    func execute(completion: @escaping UseCaseResponseClosure) {
        
        guard let repository = repository as? GenreRepository, repository.count > 0 else {
            fetchGenresFromService(completion: completion)
            return
        }
        
        fetchGenresFromCache { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                completion(.success(model: model))
            default:
                self.fetchGenresFromService(completion: completion)
            }
        }
    }
    
    private func fetchGenresFromService(completion: @escaping UseCaseResponseClosure) {
        guard let service = service as? GenreListService else {
            completion(.failure(error: UseCaseError.malformation))
            return
        }
        
        service.getGenreList { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let entity):
                completion(.success(model: entity))
                DispatchQueue.global().async {
                    self.saveGenresInCahe(genres: entity)
                }
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    private func fetchGenresFromCache(completion: @escaping UseCaseResponseClosure) {
        guard let repository = repository as? GenreRepository else {
            completion(.failure(error: UseCaseError.malformation))
            return
        }
        let genres = repository.fetch() ?? []
        
        if genres.isEmpty {
            completion(.failure(error: RepositoryError.noRecordsFound))
        } else {
            completion(.success(model: GenreListResponse(genres: genres)))
        }
    }
    
    private func saveGenresInCahe(genres: CodableEntity) {
        guard let repository = repository as? GenreRepository,
            let genres = (genres as? GenreListResponse)?.genres else {
                return
        }
        
        repository.saveGenres(genres: genres)
    }
    
}
