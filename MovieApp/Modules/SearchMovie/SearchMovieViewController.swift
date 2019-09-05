//
//  SearchMovieViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/5/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol SearchMovieViewProtocol: class {
    var presenter: SearchMoviePresenterProtocol? { get set }
}

class SearchMovieViewController: BaseViewController {
    
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchButton: AppFilledButton!
    
    var presenter: SearchMoviePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        searchTextfield.layer.cornerRadius = 15.0
        searchTextfield.clipsToBounds = true
        
        searchTextfield.leftViewMode = .always
        searchTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40.0, height: 0.0))
        
        searchButton.layer.cornerRadius = 3.0
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSearch(_ sender: Any) {
        
    }
    
}

// MARK: - SearchMovieViewProtocol

extension SearchMovieViewController: SearchMovieViewProtocol {
    
}
