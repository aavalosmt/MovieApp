//
//  SearchMovieService.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/5/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol SearchMovieService {
    func searchMovies(withKeyword: String, completion: @escaping ServiceResponseClosure)
}

class SearchMovieWebService: BaseService<MovieListResponse>, SearchMovieService {
    
    func searchMovies(withKeyword keyword: String, completion: @escaping ServiceResponseClosure) {
        let url = endpointProvider.url(forEndpoint: .MovieList(type: .search))
        
        super.request(baseUrl: url,
                      method: .get,
                      queryItems: ["query": keyword],
                      parameters: [:],
                      headers: [:],
                      completion: completion)
    }
    
    override func parse(data: Data) -> MovieListResponse? {
        return parser.parse(data: data)
    }
    
}
