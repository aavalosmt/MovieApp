//
//  BasePagerContainerViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BasePagerContainerViewController<T: TabCollectionViewCell>: BaseButtonBarPagerTabStripViewController<T> {
    
    private var theme: ThemeProtocol = ThemeProvider.shared.getTheme().object
    
    func reloadTheme() {
        theme = ThemeProvider.shared.getTheme().object
        applyTheme()
    }
    
    func applyTheme() {
        view.backgroundColor = theme.colors.backgroundColor
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: String(describing: T.self), bundle: Bundle(for: T.self), width: { _ in
            return 55.0
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: String(describing: T.self), bundle: Bundle(for: T.self), width: { _ in
            return 55.0
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return theme.colors.statusBarStyle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = theme.colors.backgroundColor
        settings.style.buttonBarItemBackgroundColor = theme.colors.backgroundColor
        settings.style.selectedBarBackgroundColor = theme.colors.selectedPrimaryColor
        
        settings.style.buttonBarItemFont = theme.fonts.tabFont
        
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: T?, newCell: T?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            
            guard let self = self else { return }
            
            guard changeCurrentIndex else { return }
            
            oldCell?.textLabel.textColor = self.theme.colors.unselectedPrimaryColor
            newCell?.textLabel.textColor = self.theme.colors.selectedPrimaryColor
            
            //oldCell?.iconImage.tintColor = self?.unselectedIconColor
            //newCell?.iconImage.tintColor = .white
        }
        super.viewDidLoad()
        
        buttonBarView.frame.origin.y = 30.0

//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        applyTheme()
    }
    
    override func configure(cell: T, for indicatorInfo: IndicatorInfo) {
        cell.textLabel.text = indicatorInfo.title
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
            let child = viewControllers[toIndex] as! IndicatorInfoProvider // swiftlint:disable:this force_cast
            UIView.performWithoutAnimation({ [weak self] () -> Void in
                guard let me = self else { return }
                me.navigationItem.leftBarButtonItem?.title =  child.indicatorInfo(for: me).title
            })
        }
    }
    
}
