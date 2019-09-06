//
//  StarRatingView.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/6/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class StarRatingView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingLabel: AppNoteLabel!
    
    func configure(rating: Double) {
        switch rating {
        case 0...0.99:
            imageView.image = UIImage(named: ImageConstants.StarRating.empty)
        case 3...4.99:
            imageView.image = UIImage(named: ImageConstants.StarRating.two)
        case 1...2.99:
            imageView.image = UIImage(named: ImageConstants.StarRating.one)
        case 3...4.99:
            imageView.image = UIImage(named: ImageConstants.StarRating.two)
        case 5...6.99:
            imageView.image = UIImage(named: ImageConstants.StarRating.three)
        case 7...8.99:
            imageView.image = UIImage(named: ImageConstants.StarRating.four)
        default:
            imageView.image = UIImage(named: ImageConstants.StarRating.full)
        }
        
        ratingLabel.text = String(rating)
    }
    
}
