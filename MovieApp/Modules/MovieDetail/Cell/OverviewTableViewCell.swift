//
//  OverviewTableViewCell.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: AppTitleLabel!
    @IBOutlet weak var dateLabel: AppTiltLabel!
    @IBOutlet weak var genreLabel: AppTiltLabel!
    @IBOutlet weak var overviewTitleLabel: AppNoteLabel!
    @IBOutlet weak var raitingContainer: UIView!
    @IBOutlet weak var overviewLabel: AppParagraphLabel!
    var starRaitingView: StarRatingView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureRatingView()
        overviewTitleLabel.text = "OVERVIEW".localized
    }
    
    func configureRatingView() {
        guard starRaitingView == nil else {
            return
        }
        
        guard let starRatingView: StarRatingView = StarRatingView.fromNib() else {
            return
        }
        
        raitingContainer.addSubview(starRatingView)
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        starRatingView.configureConstraintsToBorder(with: raitingContainer)
        self.starRaitingView = starRatingView
    }

    func configure(module: MovieDetailOverviewModule) {
        overviewLabel.text = module.description
        starRaitingView?.configure(rating: module.rating)
        dateLabel.text = module.releaseDate
        titleLabel.text = module.title
        setGenres(genres: module.genres)
    }
    
    private func setGenres(genres: [String]) {
        guard !genres.isEmpty else {
            return
        }
        
        genreLabel.text = "GENRE".localized
        
        for genre in genres {
            guard let currentText = genreLabel.text else {
                continue
            }
            var newText: String = currentText + genre
            
            if genres.last != genre {
                newText += " | "
            }
            
            genreLabel.text = newText
        }
    }
    
}
