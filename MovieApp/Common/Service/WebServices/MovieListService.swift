//
//  MovieListService.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol MovieListService {
    func getMovieList(page: Int, type: MovieListType, completion: @escaping ServiceResponseClosure)
}

class MovieListWebService: BaseService<MovieListResponse>, MovieListService {
    
    func getMovieList(page: Int, type: MovieListType, completion: @escaping ServiceResponseClosure) {
        var url: String = ""
        var parameters: [String: Any] = [:]
        
        switch type {
        case .general:
            url = String(format: endpointProvider.url(forEndpoint: .MovieList(type: type)), page)
        default:
            url = endpointProvider.url(forEndpoint: .MovieList(type: type))
            parameters = ["page": page]
        }
        
        super.request(baseUrl: url,
                      method: .get,
                      parameters: parameters,
                      headers: [:],
                      completion: completion)
    }
    
    override func parse(data: Data) -> MovieListResponse? {
        return parser.parse(data: data)
    }
    
}
