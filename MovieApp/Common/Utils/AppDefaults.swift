//
//  AppDefaults.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class AppDefaults {
    
    var defaults: UserDefaults? = UserDefaults.init(suiteName: "AppDefaults")
    
    enum AppDefaultKeys: String {
        case firstAppOpen
        case appTheme
    }

    func getTheme() -> String {
        let theme = defaults?.object(forKey: AppDefaultKeys.appTheme.rawValue) as? String ?? ""
        return theme
    }
    
    func setTheme(theme: Theme) {
        defaults?.set(theme.rawValue, forKey: AppDefaultKeys.appTheme.rawValue)
    }
    
}

