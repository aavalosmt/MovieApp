//
//  Navigatable.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/30/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol Navigatable {
    func push(_ vc: UIViewController, animated: Bool)
    func present(_ vc: UIViewController, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

extension Navigatable where Self: UIViewController {
    
    func push(_ vc: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func present(_ vc: UIViewController, completion: (() -> Void)?) {
        self.present(vc, animated: true, completion: completion)
    }

}
