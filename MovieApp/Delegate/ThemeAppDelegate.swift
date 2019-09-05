//
//  ThemeAppDelegate.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class ThemeAppDelegate: NSObject, ApplicationService {
    
    static let shared: ThemeAppDelegate = ThemeAppDelegate()
    private let themeProvider: ThemeProvider = ThemeProvider()
    
    var themeType: Theme {
        return themeProvider.getTheme()
    }
    
    var theme: ThemeProtocol {
        return themeProvider.getTheme().object
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
        applyTheme(theme: themeType)
        
        return true
    }
    
    func applyTheme(theme: Theme) {
        themeProvider.inject(theme: theme)
        
        AppLabel.appearance().appearancetextColor = self.theme.colors.textColor
        AppLabel.appearance().appearanceFont = self.theme.fonts.smallTitle
        
        TMDBLabel.appearance().appearancetextColor = self.theme.colors.tmdbColor
        TMDBLabel.appearance().appearanceFont = self.theme.fonts.tmdbFont
        
        AppNoteLabel.appearance().appearancetextColor = self.theme.colors.primary
        AppNoteLabel.appearance().appearanceFont = self.theme.fonts.smallTitle
        
        AppTitleLabel.appearance().appearancetextColor = self.theme.colors.textColor
        AppTitleLabel.appearance().appearanceFont = self.theme.fonts.title
        
        AppParagraphLabel.appearance().appearancetextColor = self.theme.colors.paragraph
        AppParagraphLabel.appearance().appearanceFont = self.theme.fonts.paragraph
        
        AppTiltLabel.appearance().appearancetextColor = self.theme.colors.tilt
        AppTiltLabel.appearance().appearanceFont = self.theme.fonts.paragraph

        AppFilledButton.appearance().fillColor = self.theme.colors.primary
        AppFilledButton.appearance().textColor = .white
        
        AppButton.appearance().tintColor = self.theme.colors.textColor
    }
    
}
