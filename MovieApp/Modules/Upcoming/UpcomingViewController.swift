//
//  UpcomingViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol UpcomingViewProtocol: class {
    var presenter: UpcomingPresenterProtocol? { get set }
}

class UpcomingViewController: BasePagerViewController {
    
    override var tabTitle: String {
        return "Upcoming"
    }

    var presenter: UpcomingPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

// MARK: - UpcomingViewProtocol

extension UpcomingViewController: UpcomingViewProtocol {
    
}
