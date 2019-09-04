//
//  StarredMovieTableViewCell.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class StarredMovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var starredLabel: AppTitleLabel!
    @IBOutlet weak var titleLabel: AppTitleLabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var overviewLabel: AppParagraphLabel!
    
    var placeholder: String {
        return ImageConstants.MovieList.filmPlaceholder
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        movieImage.image = UIImage(named: placeholder)
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = UIImage(named: placeholder)
    }
    
    func configure(movie: Movie) {
        overviewLabel.text = movie.overView
        starredLabel.text = "STARRED".localized
        
        guard !movie.genres.isEmpty else {
                    titleLabel.text = movie.title
            return
        }
        
        var genreText: String = " - "
        for genre in movie.genres {
            genreText += genre
            if movie.genres.last != genre {
                genreText += " | "
            }
        }
        
        titleLabel.text = (movie.title ?? "") + genreText
    }
    
}
