//
//  PopularViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol PopularViewProtocol: class {
    var presenter: PopularPresenterProtocol? { get set }
}

class PopularViewController: BasePagerViewController {
    
    override var tabTitle: String {
        return "POPULAR_TITLE".localized
    }
    
    var presenter: PopularPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

// MARK: - PopularViewProtocol

extension PopularViewController: PopularViewProtocol {
    
}
