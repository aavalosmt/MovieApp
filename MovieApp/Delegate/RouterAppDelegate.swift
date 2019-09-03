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

        guard let window = UIApplication.shared.keyWindow,
              let rootViewController = window.rootViewController else {
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = UINavigationController(rootViewController: initialView)
                self.window?.makeKeyAndVisible()
            return
        }
        
        initialView.view.frame = rootViewController.view.frame
        initialView.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = initialView
        }, completion: nil)
    }
    
    func startNavigation() {
        let initialView = MainRouter.startNavigation()

        guard let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController else {
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = UINavigationController(rootViewController: initialView)
                self.window?.makeKeyAndVisible()
                return
        }
        
        initialView.view.frame = rootViewController.view.frame
        initialView.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = initialView
        }, completion: nil)
    }
    
}
