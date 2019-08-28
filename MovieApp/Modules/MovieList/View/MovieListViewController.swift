//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol MovieListViewProtocol: class {
    var presenter: MovieListPresenterProtocol? { get set }
}

class MovieListViewController: UIViewController {

    var presenter: MovieListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

// MARK: - MovieListViewProtocol

extension MovieListViewController: MovieListViewProtocol {
    
}
