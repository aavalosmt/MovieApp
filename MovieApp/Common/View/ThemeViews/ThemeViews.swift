//
//  ThemeViews.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class TMDBLabel: UILabel {}

class AppLabel: UILabel {}

class AppTitleLabel: UILabel {}

class AppParagraphLabel: UILabel {}

class AppNoteLabel: UILabel {}

class AppTiltLabel: UILabel {}

extension UIAppearance where Self: UILabel {
    var appearancetextColor: UIColor {
        get {
            return textColor
        }
        set(newValue) {
            self.textColor = newValue
        }
    }
    
    var appearanceFont: UIFont {
        get {
            return font
        }
        set(newValue) {
            self.font = newValue
        }
    }
}

class AppButton: UIButton {}
class AppFilledButton: UIButton {}

extension UIAppearance where Self: AppFilledButton {
    var fillColor: UIColor {
        get {
            return backgroundColor ?? .clear
        }
        
        set(newValue) {
            backgroundColor = newValue
        }
    }
    
    var textColor: UIColor {
        get {
            return titleColor(for: .normal) ?? .white
        }
        set(newValue) {
            setTitleColor(newValue, for: .normal)
        }
    }
}
