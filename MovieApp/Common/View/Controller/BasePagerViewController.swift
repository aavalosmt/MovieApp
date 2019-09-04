//
//  BasePagerViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BasePagerViewController: BaseViewController, TabBarViewProtocol {
    
    var tabTitle: String {
        return ""
    }
    
    var tabIcon: UIImage? {
        return nil
    }
    
    weak var container: BasePagerContainerViewController<TabCollectionViewCell>?
    
}

extension BasePagerViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: tabTitle)
    }
    
}

