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
    
    func execute(keyWord: String, completion: @escaping UseCaseResponseClosure) {
        
        guard let service = service as? SearchMovieService else {
            completion(.failure(error: UseCaseError.malformation))
            return
        }
        
        service.searchMovies(withKeyword: keyWord, completion: { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let entity):
                completion(.success(model: entity))
//                DispatchQueue.global().async {
//                    self.saveMoviesInCahe(page: page, type: type, movies: entity)
//                }
            case .failure(let error):
                completion(.failure(error: error))
            }
        })
        
    }
    
}
