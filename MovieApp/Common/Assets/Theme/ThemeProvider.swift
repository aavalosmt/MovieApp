//
//  ThemeProvider.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

class ThemeProvider {
    
    static let shared: ThemeProvider = ThemeProvider()
    static let defaultTheme: Theme = .dark

    private let appDefaults: AppDefaults = AppDefaults()
    private var currentTheme: Theme
    
    init() {
        let rawTheme = appDefaults.getTheme()
        self.currentTheme = Theme(rawValue: rawTheme) ?? ThemeProvider.defaultTheme
    }
    
    func getTheme() -> Theme {
        return currentTheme
    }
    
    func inject(theme: Theme) {
        self.currentTheme = theme
        appDefaults.setTheme(theme: theme)
    }
}
