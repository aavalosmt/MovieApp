//
//  CarouselMovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class CarouselMovieCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var movieImage: UIImageView!
    
    // MARK: - Variables

    var image: UIImage? {
        get {
            return movieImage.image
        }
        set(newValue) {
            guard let im = newValue else {
                movieImage.image = UIImage(named: placeholder)
                return
            }
            
            UIView.transition(with: movieImage, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                self.movieImage.image = im
            }, completion: nil)
        }
    }
    
    var placeholder: String {
        return ImageConstants.MovieList.filmPlaceholder
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let transition = CATransition()
        transition.duration = 1.0
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        movieImage.layer.add(transition, forKey: nil)
        
        movieImage.image = UIImage(named: placeholder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = UIImage(named: placeholder)
    }
    
}

// MARK: - CarouselItem

extension CarouselMovieCollectionViewCell: CarouselItem {
    
    typealias ItemDataType = Movie
    typealias ItemCellType = CarouselMovieCollectionViewCell
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
    func configureCellAtIndexPath(_ indexPath: IndexPath, item: Movie) -> CarouselMovieCollectionViewCell {
        
        
        return self
    }
    
    func willDisplayCellAtIndexPath(_ indexPath: IndexPath, item: Movie) {

    }
    
    func updateCellImage(image: UIImage?) {
        DispatchQueue.main.async {
            self.image = image
        }
    }
}
