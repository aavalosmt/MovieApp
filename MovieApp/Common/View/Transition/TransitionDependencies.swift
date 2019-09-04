//
//  TransitionDependencies.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class TransitionDependencies {
    
    var modalPresentationStyle: UIModalPresentationStyle
    weak var transitioningDelegate: UIViewControllerTransitioningDelegate?
    weak var sharingView: UIView?
    
    init(modalPresentationStyle: UIModalPresentationStyle,
         transitioningDelegate: UIViewControllerTransitioningDelegate?,
         sharingView: UIView?) {
        self.modalPresentationStyle = modalPresentationStyle
        self.transitioningDelegate = transitioningDelegate
        self.sharingView = sharingView
    }
    
    static let `default` = TransitionDependencies(
        modalPresentationStyle: .custom,
        transitioningDelegate: nil,
        sharingView: nil)
    
}
