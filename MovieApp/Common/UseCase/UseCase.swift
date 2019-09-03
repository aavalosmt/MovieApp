//
//  UseCase.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

enum UseCaseError: Error {
    case malformation
}

enum UseCaseResponse {
    case success(model: CodableEntity)
    case failure(error: Error)
}

typealias UseCaseResponseClosure = (UseCaseResponse) -> Void

class UseCaseImpl {
    
    var service: Service?
    var repository: Repository?
    
    init(service: Service? = nil, repository: Repository? = nil) {
        self.service = service
        self.repository = repository
    }
    
}
