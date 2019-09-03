//
//  RouterAppDelegate.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class RouterAppDelegate: NSObject, ApplicationService {
    
    static let shared: RouterAppDelegate = RouterAppDelegate()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        startLoader()
        
        return true
    }
    
    func startLoader() {
        let initialView = MainRouter.startLoader()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: initialView)
        window?.makeKeyAndVisible()
    }
    
    func startNavigation() {
        let initialView = MainRouter.startNavigation()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: initialView)
        window?.makeKeyAndVisible()
    }
    
}
