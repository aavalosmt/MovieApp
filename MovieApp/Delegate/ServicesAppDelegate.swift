//
//  ServicesAppDelegate.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

enum Environment {
    case development
    case none
    
    var baseUrl: String {
        switch self {
        case .development:
            return "https://api.themoviedb.org"
        default:
            return ""
        }
    }
    
    var imageBaseUrl: String {
        switch self {
        case .development:
            return "https://image.tmdb.org/t/p/w300"
        default:
            return ""
        }
    }
    
    var thumbnailBaseUrl: String {
        switch self {
        case .development:
            return "https://image.tmdb.org/t/p/w200"
        default:
            return ""
        }
    }
}

class ServicesAppDelegate: NSObject, ApplicationService {
    
    static let shared: ServicesAppDelegate = ServicesAppDelegate()
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
  
        EndpointProvider.shared.inject(environment: .development)
        
        return true
    }
    
}
