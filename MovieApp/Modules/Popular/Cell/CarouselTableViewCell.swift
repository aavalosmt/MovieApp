//
//  CarouselTableViewCell.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class CarouselTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    weak var delegate: CarouselDataSourceDelegate? {
        didSet {
            self.carouselDataSource.delegate = delegate
        }
    }
    
    @IBOutlet weak var titleLabel: AppTitleLabel!
    @IBOutlet weak var carouselContainer: UIView!
    @IBOutlet weak var paragraphLabel: AppParagraphLabel!
    
    private var layout: CarouselCollectionViewLayout!
    var carousel: Carousel<Movie, CarouselMovieCollectionViewCell>!
    private var carouselDataSource: CarouselDataSource<Movie, CarouselMovieCollectionViewCell>!
    private var carouselData: CarouselDataContainer<Movie>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        configureCarousel()
    }
    
    private func configureCarousel() {
        guard carousel == nil else {
            return
        }
        configureDataSource()
        
        self.layout = CarouselCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.carousel = Carousel<Movie, CarouselMovieCollectionViewCell>(
            frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: carouselContainer.frame.height),
            collectionViewLayout: layout)
        
        carousel.didPageChangedClosure = { [weak self] page in
            guard let self = self, let movie = self.carouselData.data[safe: page] else { return }
            self.paragraphLabel.text = movie.overView
            self.titleLabel.text = movie.title
        }
        
        self.carousel.setCarouselDataSource(carouselDataSource)
        self.carousel.translatesAutoresizingMaskIntoConstraints = false
        self.carousel.backgroundColor = UIColor.clear
        self.carousel.reloadData()
        
        carouselContainer.addSubview(self.carousel)
        self.carousel.configureConstraintsToBorder(with: carouselContainer)
        carouselContainer.layoutIfNeeded()
    }
    
    private func configureDataSource() {
        guard carouselDataSource == nil else {
            return
        }
        self.carouselData = CarouselDataContainer<Movie>()
        self.carouselDataSource = CarouselDataSource<Movie, CarouselMovieCollectionViewCell>(container: carouselData)
        self.carouselDataSource.delegate = delegate
    }
    
    func configure(with movies: [Movie]) {
        self.carouselData.data = movies
        self.carousel.reloadData()
        
        if let first = movies.first {
            self.paragraphLabel.text = first.overView
            self.titleLabel.text = first.title
        }
    }
    
}
