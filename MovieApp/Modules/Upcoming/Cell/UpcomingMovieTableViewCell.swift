//
//  UpcomingMovieTableViewCell.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class UpcomingMovieTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var releaseDateLabel: AppNoteLabel!
    @IBOutlet weak var titleLabel: AppTitleLabel!
    @IBOutlet weak var overViewLabel: AppParagraphLabel!
    
    // MARK: - Variables
    
    weak var movie: MovieEntity?
    
    // MARK: - Constants
    
    var placeholder: String {
        return ImageConstants.MovieList.filmPlaceholder
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = UIImage(named: placeholder)
    }
    
    // MARK: - Public methods
    
    func configure(with movie: Movie) {
        self.movie = movie as? MovieEntity
        titleLabel.text = movie.title
        releaseDateLabel.text = "RELEASE_DATE".localized + (movie.releaseDate ?? "")
        overViewLabel.text = movie.overView
    }
}
