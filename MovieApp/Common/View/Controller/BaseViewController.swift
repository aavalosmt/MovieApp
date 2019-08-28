//
//  BaseViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var theme: ThemeProtocol = ThemeProvider.shared.getTheme().object
    
    func reloadTheme() {
        theme = ThemeProvider.shared.getTheme().object
        applyTheme()
    }
    
    func applyTheme() {
        view.backgroundColor = theme.colors.backgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
    }
    
}
