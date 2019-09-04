//
//  GenreCollectionViewCell.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: AppTitleLabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.layer.cornerRadius = 5.0
    }
    
    func configure(withGenre genre: Genre) {
        titleLabel.text = genre.name
        contentView.backgroundColor = .random()
    }

}
