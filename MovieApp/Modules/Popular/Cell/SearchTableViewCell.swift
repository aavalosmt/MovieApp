//
//  SearchTableViewCell.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var titleLabel: AppTitleLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        titleLabel.text = "CATEGORIES".localized
    }
    
}
