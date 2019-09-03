//
//  BaseParser.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

protocol Parser {
    associatedtype T: CodableEntity
    
    func parse(data: Data) -> T?
}

class BaseParser<T: CodableEntity>: Parser {
    
    func parse(data: Data) -> T? {
        return nil
    }
    
}

class JsonParser<T: CodableEntity>: BaseParser<T> {
    
    override func parse(data: Data) -> T? {
        return jsonDecode(data: data)
    }
    
    private func jsonDecode(data: Data) -> T? {
        let decodedModel = try? JSONDecoder().decode(T.self, from: data)
        return decodedModel
    }
    
}
