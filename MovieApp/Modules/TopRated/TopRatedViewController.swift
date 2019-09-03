//
//  TopRatedViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol TopRatedViewProtocol: class {
    var presenter: TopRatedPresenterProtocol? { get set }
}

class TopRatedViewController: BasePagerViewController {
    
    override var tabTitle: String {
        return "TOP_RATED_TITLE".localized
    }
    
    var presenter: TopRatedPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

// MARK: - TopRatedViewProtocol

extension TopRatedViewController: TopRatedViewProtocol {
    
}

// MARK: - IndicatorInfoProvider


