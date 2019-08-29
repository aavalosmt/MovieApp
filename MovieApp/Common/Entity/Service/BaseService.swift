//
//  BaseService.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

public enum TimeOutInterval: Double {
    case oneMinute = 60.0
    case thirtySeconds = 30.0
}

/**
 * This enum defines the http methods used in a request
 */
public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

/**
 * This enum defines the http errors that can be processed in a request by a service
 */
enum ServiceError: Int, Error {
    case parseError
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
    case unprocesableEntity = 422
    case serverError = 500
}

/**
 * This enum defines the possible response result a request can return
 */
enum ServiceResponse {
    case paginatedSuccess(results: [CodableEntity])
    /// Returned when the service completes and parses the given model with no errors
    case success(entity: CodableEntity)
    /// Returned when the service completes with an http error or cannot parse the given model
    case failure(error: ServiceError)
}

typealias ServiceResponseClosure = ((ServiceResponse) -> Void)

protocol Service {

    var executionQueue: DispatchQueue { get set }
    
    func request(baseUrl: String,
                 method: RequestMethod,
                 parameters: Dictionary<String, Any>,
                 headers: Dictionary<String, String>,
                 paginated: Bool,
                 page: Int,
                 limit: Int,
                 completion: @escaping ServiceResponseClosure
    )
    
    func processResponse(baseUrl: String,
                         method: RequestMethod,
                         parameters: Dictionary<String, Any>,
                         headers: Dictionary<String, String>,
                         data: Data?,
                         paginated: Bool,
                         page: Int,
                         limit: Int,
                         urlResponse: HTTPURLResponse,
                         completion: @escaping ServiceResponseClosure)
}

/**
 * Base class to perform http request given a Codable Model
 *
 */

class BaseService<Entity: CodableEntity>: Service {
    
    // TODO: Cipher Api Key
    private let apiKey: String = "6de141add9b48d75416a80e7d8e74967"
    
    private let configuration: URLSessionConfiguration
    private let cachePolicy: URLRequest.CachePolicy
    private let timeOut: TimeInterval
    private var results: [Entity] = []
    let endpointProvider: EndpointProvider
    var parser: BaseParser<Entity>

    init(configuration: URLSessionConfiguration = .default,
         cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData,
         timeOut: TimeInterval = TimeOutInterval.thirtySeconds.rawValue,
         parser: BaseParser<Entity> = JsonParser<Entity>(),
         endpointProvider: EndpointProvider = .shared) {
        self.configuration = configuration
        self.cachePolicy = cachePolicy
        self.timeOut = timeOut
        self.parser = parser
        self.endpointProvider = endpointProvider
    }
    
    var executionQueue: DispatchQueue = .global(qos: .background)
    
    /**
     * Performs a http request in background queue
     * - Parameters:
     *    - url: The string path url destination to send the request
     *    - method: The RequestMethod to perform the request
     *    - parameters: A Dictionary<String, Any> with the parameters to be encoded in the request
     *    - headers: A Dictionary<String, String> to be encoded in the http headers
     *    - completion: A ServiceResponse closure containing the result of the request
     */
    func request(baseUrl: String,
                 method: RequestMethod,
                 parameters: Dictionary<String, Any>,
                 headers: Dictionary<String, String>,
                 paginated: Bool,
                 page: Int,
                 limit: Int,
                 completion: @escaping ServiceResponseClosure) {
        
        var endpointURL: String = paginated ? String(format: baseUrl, page): baseUrl
        
        if method == .get {
            endpointURL += "?" + ServiceConstants.apiKey + "=" + apiKey
        }
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(error: ServiceError.badRequest))
            return
        }
        
        var request: URLRequest = URLRequest(url: url, cachePolicy: self.cachePolicy, timeoutInterval: self.timeOut)
        request.httpMethod = method.rawValue
        if method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        request.allHTTPHeaderFields = headers
        
        let session: URLSession = URLSession(configuration: self.configuration)
        let task = session.dataTask(with: request) { (body, response, error) in
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(error: ServiceError.serverError))
                return
            }
            self.processResponse(baseUrl: baseUrl, method: method, parameters: parameters, headers: headers, data: body, paginated: paginated, page: page, limit: limit, urlResponse: urlResponse, completion: completion)
        }
        task.resume()
    }
    
    /**
     * Abstract method that needs to be overwritten to perform the data parsing into a codable model
     */
    func parse(data: Data) -> Entity? {
        return nil
    }
    
    /**
     * Decides wheter or not a request response is successful based on the statusCode and the parsed Model from the `parse(data:)` method
     */
    func processResponse(baseUrl: String,
                         method: RequestMethod,
                         parameters: Dictionary<String, Any>,
                         headers: Dictionary<String, String>,
                         data: Data?,
                         paginated: Bool,
                         page: Int,
                         limit: Int,
                         urlResponse: HTTPURLResponse,
                         completion: @escaping ServiceResponseClosure) {
        
        guard let data = data else {
            completion(.failure(error: ServiceError.badRequest))
            return
        }
        switch urlResponse.statusCode {
        case 200:
            guard let entity = parse(data: data) else {
                completion(.failure(error: ServiceError.parseError))
                return
            }
            
            if paginated {
                results.append(entity)
                guard page <= limit else {
                    
                    if !results.isEmpty {
                        completion(.paginatedSuccess(results: results))
                    } else {
                        completion(.failure(error: ServiceError.parseError))
                    }
                    return
                }
                
                request(baseUrl: baseUrl, method: method, parameters: parameters, headers: headers, paginated: paginated, page: page + 1, limit: limit, completion: completion)
                
                completion(.success(entity: entity))
            } else {
                completion(.success(entity: entity))
            }
            
        default:
            guard let serviceError = ServiceError(rawValue: urlResponse.statusCode) else {
                completion(.failure(error: ServiceError.badRequest))
                return
            }
            if paginated, !results.isEmpty {
                completion(.paginatedSuccess(results: results))
            } else {
                completion(.failure(error: serviceError))
            }
        }
    }
}
