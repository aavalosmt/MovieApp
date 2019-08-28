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
}

protocol ColorPalleteProtocol {
    var textColor: UIColor { get }
    
    var primary: UIColor { get }
    var light: UIColor { get }
    var dark: UIColor { get }
    var backgroundColor: UIColor { get }
}

struct DarkTheme: ThemeProtocol {
    var fonts: AppFontsProtocol = DarkFonts()
    var colors: ColorPalleteProtocol = DarkPallete()
}

struct DarkFonts: AppFontsProtocol {
    var title: UIFont = UIFont.systemFont(ofSize: 17.0)
    var paragraph: UIFont = UIFont.systemFont(ofSize: 14.0)
    var smallTitle: UIFont = UIFont.systemFont(ofSize: 15.0)
}

struct DarkPallete: ColorPalleteProtocol {
    var textColor: UIColor       = .white
    var primary: UIColor         = .white
    var light: UIColor           = UIColor(rgb: 0x484848)
    var dark: UIColor            = .black
    var backgroundColor: UIColor = UIColor(rgb: 0x212121)
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
