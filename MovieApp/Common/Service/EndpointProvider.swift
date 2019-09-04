//
//  EndpointProvider.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

enum Endpoint {
    case MovieList(type: MovieListType)
    case Image(path: String)
    case Genres
    
    var path: String {
        switch self {
        case .MovieList(let type):
            return getMovieListPath(type: type)
        case .Image(let path):
            return path
        case .Genres:
            return "/3/genre/movie/list"
        }
    }
    
    private func getMovieListPath(type: MovieListType) -> String {
        switch type {
        case .topRated:
            return "/3/movie/top_rated"
        case .upcoming:
            return "/3/movie/upcoming"
        case .popular:
            return "/3/movie/popular"
        }
    }
}

class EndpointProvider {
    
    static let shared: EndpointProvider = EndpointProvider()
    
    private var environment: Environment = .none
    
    func url(forEndpoint endpoint: Endpoint) -> String {
        return environment.baseUrl + endpoint.path
    }
    
    func imageUrl(forEndpoint endpoint: Endpoint, size: ImageSize) -> String {
        return (size == .full ? environment.imageBaseUrl : environment.thumbnailBaseUrl) + endpoint.path
    }
}

extension EndpointProvider {
    
    func inject(environment: Environment) {
        self.environment = environment
    }
    
}
