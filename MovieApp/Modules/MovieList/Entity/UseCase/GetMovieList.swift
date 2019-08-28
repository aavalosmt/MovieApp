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
        
        guard let service = service as? MovieListService else {
            completion(.failure(error: UseCaseError.malformation))
            return
        }
        
        service.getMovieList { response in
            switch response {
            case .paginatedSuccess(let results):
                completion(.paginatedSuccess(results: results))
            case .success(let entity):
                completion(.success(model: entity))
            case .failure(let error):
                completion(.failure(error: error))
                
            }
        }
    }
    
}
