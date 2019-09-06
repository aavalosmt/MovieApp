//
//  Repository.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/6/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import SystemConfiguration

protocol ReachabilityProtocol {
    var isReachable: Bool { get }
}

class Reachability: ReachabilityProtocol {
    
    static let shared = Reachability()
    
    private var reachability: SCNetworkReachability?
    private var flags: SCNetworkReachabilityFlags

    init() {
        self.flags = SCNetworkReachabilityFlags()
        self.reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
        
        SCNetworkReachabilityGetFlags(reachability!, &flags)
    }
    
    var isReachable: Bool {
        return flags.contains(.reachable)
    }
    
}
