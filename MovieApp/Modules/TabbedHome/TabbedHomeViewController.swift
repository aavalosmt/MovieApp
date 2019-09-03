//
//  TabbedHomeViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol TabbedHomeViewProtocol: class {
    var presenter: TabbedHomePresenterProtocol? { get set }
    var tabControllers: [TabBarViewProtocol] { get }
}

class TabbedHomeViewController: BasePagerContainerViewController<TabCollectionViewCell> {

    var presenter: TabbedHomePresenterProtocol?
    var tabControllers: [TabBarViewProtocol]
    
    init(tabControllers: [TabBarViewProtocol]) {
        self.tabControllers = tabControllers
        super.init(nibName: String(describing: TabbedHomeViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return tabControllers.compactMap({ $0 as? UIViewController })
    }
    
}

// MARK: - TabbedHomeViewProtocol

extension TabbedHomeViewController: TabbedHomeViewProtocol {
    
}
