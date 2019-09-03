//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var title: AppLabel!
    
    // MARK: - Variables
    
    weak var movie: MovieEntity?
    
    // MARK: - Constants
    
    var placeholder: String {
        return ImageConstants.MovieList.filmPlaceholder
    }
    
    // MARK: - Cell LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.image = UIImage(named: placeholder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = UIImage(named: placeholder)
    }

    // MARK: - Public methods
    
    func configure(with movie: MovieEntity) {
        self.movie = movie
        title.text = movie.title
    }
    
}
