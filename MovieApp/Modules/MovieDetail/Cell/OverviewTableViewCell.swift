//
//  OverviewTableViewCell.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var overviewLabel: AppParagraphLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(overview: String) {
        overviewLabel.text = overview
    }
    
}
