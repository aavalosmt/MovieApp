//
//  EndpointProvider.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

enum Endpoint {
    case MovieList
    case Image(path: String)
    
    var path: String {
        switch self {
        case .MovieList:
            return "/list/%d"
        case .Image(let path):
            return path
        }
    }
}

class EndpointProvider {
    
    static let shared: EndpointProvider = EndpointProvider()
    
    private var environment: Environment = .none
    
    func url(forEndpoint endpoint: Endpoint) -> String {
        return environment.baseUrl + endpoint.path
    }
    
    func imageUrl(forEndpoint endpoint: Endpoint) -> String {
        return environment.imageBaseUrl + endpoint.path
    }
    
    func thumbnailUrl(forEndpoint endpoint: Endpoint) -> String {
        return environment.thumbnailBaseUrl + endpoint.path
    }
}

extension EndpointProvider {
    
    func inject(environment: Environment) {
        self.environment = environment
    }
    
}
