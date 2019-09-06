//
//  GeneralTestsStubSetup.swift
//  MovieAppTests
//
//  Created by Aldo Antonio Martinez Avalos on 9/6/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import OHHTTPStubs

@testable import MovieApp

enum statusCode: Int32 {
    case OK = 200
    case BadRequest = 400
    case UnauthorizedCode = 401
    case NoService = 501
    case UnprocessableEntity = 422
    case UnknowCode = 0
    case NoConection = -1009
    case NotFound = 404
}

class GeneralTestsStubSetup: StubSetup {
    
    init() {
        super.init()
        setup()
    }
    
    deinit {
        removeStubs()
    }

    func registerStubOk(for endpoint: Endpoint, resource: String? = nil, status: statusCode = .OK) {
        let urlStub = url(for: endpoint)
        let stubEndPoint = StubEndpoint(path: urlStub, resource: resource ?? "", status: status.rawValue)
        
        self.isDown = false
        registerStub(stubEndPoint)
    }
    
    func registerStubEmptyOk(for endpoint: Endpoint) {
        let urlStub = url(for: endpoint)
        let stubEndPoint = StubEndpoint(path: urlStub, resource: CommonUnitTestsConstants.Resources.jsonSuccessResponse, status: statusCode.OK.rawValue)
        
        self.isDown = false
        registerStub(stubEndPoint)
    }
    
    func registerStubBadRequest(for endpoint: Endpoint, resource: String? = nil, status: statusCode = .BadRequest) {
        let urlStub = url(for: endpoint)
        let stubEndPoint = StubEndpoint(path: urlStub, resource: resource ?? CommonUnitTestsConstants.Resources.jsonFailResponse, status: status.rawValue)
        
        self.isDown = false
        registerStub(stubEndPoint)
    }
    
    func registerStubNotConnected(for endpoint: Endpoint) {
        let urlStub = url(for: endpoint)
        let stubEndPoint = StubEndpoint(path: urlStub, resource: "", status: statusCode.NoService.rawValue)
        
        self.isDown = true
        registerStub(stubEndPoint)
    }
    
    func registerCustomStub(for endpoint: String, resource: String, status: statusCode, isDown: Bool = false) {
        let stubEndPoint = StubEndpoint(path: endpoint, resource: resource, status: status.rawValue)
        self.isDown = isDown
        registerStub(stubEndPoint)
    }
    
    func registerStubs(for stubEndpoints: StubEndpoint..., isDown: Bool = false) {
        self.isDown = isDown
        stubEndpoints.forEach { stubEndpoint in
            registerStub(stubEndpoint)
        }
    }
}
