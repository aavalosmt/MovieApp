//
//  Theme.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    var fonts: AppFontsProtocol { get }
    var colors: ColorPalleteProtocol { get }
}

protocol AppFontsProtocol {
    var title: UIFont { get }
    var paragraph: UIFont { get }
    var smallTitle: UIFont { get }
    
    var tabFont: UIFont { get }
    var tmdbFont: UIFont { get }
}

protocol ColorPalleteProtocol {
    var textColor: UIColor { get }
    var tmdbColor: UIColor { get }
    var primary: UIColor { get }
    var light: UIColor { get }
    var dark: UIColor { get }
    var backgroundColor: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
    
    var selectedPrimaryColor: UIColor { get }
    var unselectedPrimaryColor: UIColor { get }
}

struct DarkTheme: ThemeProtocol {
    var fonts: AppFontsProtocol = DarkFonts()
    var colors: ColorPalleteProtocol = DarkPallete()
}

struct DarkFonts: AppFontsProtocol {
    var title: UIFont = UIFont.systemFont(ofSize: 17.0)
    var paragraph: UIFont = UIFont.systemFont(ofSize: 14.0)
    var smallTitle: UIFont = UIFont.systemFont(ofSize: 15.0)
    
    var tabFont: UIFont = UIFont(name: FontName.Helvetica.light.rawValue, size: 17.0) ?? FontName.defaultFont
    var tmdbFont: UIFont = UIFont(name: FontName.Helvetica.light.rawValue, size: 12.0) ?? FontName.defaultFont
}

struct DarkPallete: ColorPalleteProtocol {
    var textColor: UIColor               = UIColor.white
    var tmdbColor: UIColor               = UIColor(rgb: 0x60D17D)
    var primary: UIColor                 = UIColor(rgb: 0xFFC400)
    var light: UIColor                   = UIColor(rgb: 0x484848)
    var dark: UIColor                    = UIColor.black
    var backgroundColor: UIColor         = UIColor(rgb: 0x212121)
    var statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.lightContent
    var selectedPrimaryColor: UIColor    = UIColor(rgb: 0xFFC400)
    var unselectedPrimaryColor: UIColor  = UIColor.white
}

enum Theme: String {
    case light
    case dark
    
    var object: ThemeProtocol {
        switch self {
        default:
            return DarkTheme()
        }
    }
}
