//
//  Stub.swift
//  MovieAppTests
//
//  Created by Aldo Antonio Martinez Avalos on 9/6/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import OHHTTPStubs

@testable import MovieApp

enum StubSpeed: RawRepresentable {
    
    case gprs, wifi
    
    typealias RawValue = Double
    
    init?(rawValue: Double) {
        switch rawValue {
        case OHHTTPStubsDownloadSpeedGPRS: self = .gprs
        case OHHTTPStubsDownloadSpeedWifi: self = .wifi
        default:
            return nil
        }
    }
    
    var rawValue: Double {
        switch self {
        case .gprs: return OHHTTPStubsDownloadSpeedGPRS
        case .wifi: return OHHTTPStubsDownloadSpeedWifi
        }
    }
}

// MARK: - StubManager Protocol
protocol StubManager: class {
    var resources: [String: Any] { get set }
    var isDown: Bool { get set }
    var endpointProvider: EndpointProvider { get set }
    var baseURL: String! { get set }
    typealias JSON = [StubEndpoint]
    
    var endpoints: [StubEndpoint] { get }
    
    func setup()
    func unset()
}

// MARK: - StubManager extension implementation
extension StubManager {
    
   func url(for endpoint: Endpoint, removeParams: Bool = false) -> String {
        var ep = endpointProvider.url(forEndpoint: endpoint)
        if removeParams, let cleanEp = ep.split(separator: "?").first.map(String.init) {
            ep = cleanEp
        }
        return ep
    }

    func path(for endpoint: Endpoint, removeParams: Bool = false) -> String? {
        var ep = endpointProvider.url(forEndpoint: endpoint)
        if removeParams, let cleanEp = ep.split(separator: "?").first.map(String.init) {
            ep = cleanEp
        }
        guard let url = URL(string: ep) else { return nil }
        return url.path
        
    }
    
    func removeStubs() {
        OHHTTPStubs.removeAllStubs()
    }
    
    fileprivate func prepare(stub stubModel: StubEndpoint) {
        
        var testBlock: OHHTTPStubsTestBlock
        
        switch stubModel.semantic {
        case .beginsWith:
            testBlock = pathStartsWith(stubModel.path)
        case .regex:
            testBlock = pathMatches(stubModel.path)
        default:
            testBlock = absoluteURL(stubModel.path)
        }
        
        stub(condition: testBlock) { _ -> OHHTTPStubsResponse in
            if !self.isDown {
                let resource = self.assertJson(forResource: stubModel.resource)
                
                if let resourceDict = try? JSONSerialization.jsonObject(with: resource, options: []) as? [String : Any] {
                    self.resources[stubModel.path] = resourceDict
                }
                let stub = OHHTTPStubsResponse(data: resource, statusCode: stubModel.status, headers:nil)
                
                guard let speed = stubModel.speed else { return stub }
                return stub.responseTime(speed.rawValue)
                
            } else {
                let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
                return OHHTTPStubsResponse(error: notConnectedError)
            }
            
        }
    }
    
    func setup() {
        registerStubs(endpoints)
    }

    func registerStub(_ stub: StubEndpoint) {
        prepare(stub: stub)
    }
    
    func registerStubs(_ stubs: [StubEndpoint]) {
        for stub in stubs {
            registerStub(stub)
        }
    }
    
    func assertJson(forResource json: String, errorMsg: String? = nil) -> Data {
        var data = Data()
        if let url = Bundle(for: type(of: self)).url(forResource: json, withExtension: "json") {
            do {
                data = try Data(contentsOf: url as URL)
            } catch {
                return Data()
            }
        }
        return data
    }
    
    fileprivate func absoluteURL(_ urlString: String) -> OHHTTPStubsTestBlock {
        let urlEndpoint = URL(string: urlString)
        
        return { request in request.url?.absoluteURL == urlEndpoint }
    }
    
    func each(test: () -> Void) {
        self.endpoints.forEach { (item) in
            registerStub(item)
            test()
        }
    }
}

// MARK: - StubSemantic.

enum StubSemantic {
    case absolute
    case beginsWith
    case regex
}

// MARK: - StubEndpoint

struct StubEndpoint {
    var path: String
    var resource: String
    var status: Int32
    var speed: StubSpeed?
    let semantic: StubSemantic
    
    init(path: String, resource: String, status: Int32, speed: StubSpeed? = nil, semantic: StubSemantic = .absolute) {
        self.path = path
        self.resource = resource
        self.status = status
        self.speed = speed
        self.semantic = semantic
    }
}

// MARK: - Stub Setup Abstract Base Class
class StubSetup: StubManager {
    
    var resources: [String: Any] = [:]
    var isDown: Bool = false
    var endpointProvider: EndpointProvider
    var baseURL: String!
    
    var endpoints: [StubEndpoint] { return [] }
    
    init(with json: JSON, endpointProvider: EndpointProvider = .shared) {
        self.endpointProvider = endpointProvider
        precondition(type(of: self) !== StubSetup.self, "StubSetup is an abstract class, do not try to create instance of this class")
    }
    
    init(endpointProvider: EndpointProvider = .shared) {
        self.endpointProvider = endpointProvider

        precondition(type(of: self) !== StubSetup.self, "StubSetup is an abstract class, do not try to create instance of this class")
    }
    
    func unset() {
        removeStubs()
    }
    
}

