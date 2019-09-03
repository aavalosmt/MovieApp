//
//  GenreListService.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol GenreListService {
    func getGenreList(completion: @escaping ServiceResponseClosure)
}

class GenreListWebService: BaseService<GenreListResponse>, GenreListService {
    
    func getGenreList(completion: @escaping ServiceResponseClosure) {
        let url = endpointProvider.url(forEndpoint: .Genres)
        
        super.request(baseUrl: url,
                      method: .get,
                      queryItems: [:],
                      parameters: [:],
                      headers: [:],
                      completion: completion)
    }
    
    override func parse(data: Data) -> GenreListResponse? {
        return parser.parse(data: data)
    }
    
}
