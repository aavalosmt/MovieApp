//
//  MovieListService.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol MovieListService {
    func getMovieList(completion: @escaping ServiceResponseClosure)
}

class MovieListWebService: BaseService<MovieListResponse>, MovieListService {
    
    func getMovieList(completion: @escaping ServiceResponseClosure) {
        let url = String(format: endpointProvider.url(forEndpoint: .MovieList), 1)
        
        super.request(baseUrl: url,
                      method: .get,
                      parameters: [:],
                      headers: [:],
                      paginated: true,
                      page: 1,
                      limit: 10,
                      completion: completion)
    }
    
    override func parse(data: Data) -> MovieListResponse? {
        return parser.parse(data: data)
    }
    
}
