//
//  TopRatedViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol TopRatedViewProtocol: class {
    var presenter: TopRatedPresenterProtocol? { get set }
}

class TopRatedViewController: BasePagerViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var carouselContainer: UIView!
    @IBOutlet weak var overviewLabel: AppNoteLabel!
    @IBOutlet weak var yearLabel: AppTiltLabel!
    @IBOutlet weak var overviewDescriptionLabel: AppParagraphLabel!
    @IBOutlet weak var genreLabel: AppTiltLabel!
    @IBOutlet weak var releaseDateLabel: AppTiltLabel!
    
    lazy var readFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = DateFormat.yyyy_mm_dd.rawValue
        return df
    }()
    
    lazy var formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = DateFormat.yyyy.rawValue
        return df
    }()
    
    private var layout: CarouselCollectionViewLayout!
    private var carousel: Carousel<Movie, CarouselMovieCollectionViewCell>!
    private var carouselDataSource: CarouselDataSource<Movie, CarouselMovieCollectionViewCell>!
    private var carouselData: CarouselDataContainer<Movie>!
    
    override var tabTitle: String {
        return "TOP_RATED_TITLE".localized
    }
    
    var presenter: TopRatedPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCarousel()
        bind()
    }
    
    private func configureStrings() {
        overviewLabel.text = "OVERVIEW".localized
        
        if let firstMovie = carouselData.data.first {
            configureView(withMovie: firstMovie)
        }
    }
    
    // MARK: - Private methods
    
    private func bind() {
        presenter?
            .moviesChanged
            .emit(onNext: { [weak self] results in
                guard let self = self else { return }
                self.carouselData.data.append(contentsOf: results)
                
                DispatchQueue.main.async {
                    self.carousel.reloadData()
                    self.configureStrings()
                }
            }).disposed(by: disposeBag)
        
        presenter?
            .imageChanged
            .emit(onNext: { [weak self] (index, image) in
                DispatchQueue.main.async {
                    self?.carousel.didFetchImage(for: index, image: image)
                }
            }).disposed(by: disposeBag)
        
        if let presenter = presenter {
            carousel.rx
                .reachedLast
                .bind(to: presenter.reachedBottomTrigger)
                .disposed(by: disposeBag)
        }
        
        presenter?.viewDidLoadTrigger.onNext(())
    }
    
    // MARK: - Carousel
    
    private func configureDataSource() {
        guard carouselDataSource == nil else {
            return
        }
        self.carouselData = CarouselDataContainer(data: [])
        self.carouselDataSource = CarouselDataSource<Movie, CarouselMovieCollectionViewCell>(container: carouselData)
        self.carouselDataSource.delegate = self
    }
    
    private func configureCarousel() {
        guard carousel == nil else {
            return
        }
        configureDataSource()
        
        self.layout = CarouselCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.carousel = Carousel<Movie, CarouselMovieCollectionViewCell>(
            frame: CGRect(x: 0, y: 0, width: carouselContainer.frame.width, height: carouselContainer.frame.height),
            collectionViewLayout: layout)
        
        carousel.didPageChangedClosure = { [weak self] page in
            guard let self = self, let movie = self.carouselData.data[safe: page] else { return }
            self.configureView(withMovie: movie)
        }
        
        self.carousel.setCarouselDataSource(carouselDataSource)
        
        self.carousel.backgroundColor = UIColor.clear
        self.carousel.reloadData()
        
        carouselContainer.addSubview(self.carousel)
        carouselContainer.layoutIfNeeded()
    }
    
    private func configureView(withMovie movie: Movie) {
        overviewDescriptionLabel.text = movie.overView
        
        genreLabel.text = "GENRE".localized
        
        for genre in movie.genres {
            guard let currentText = genreLabel.text else {
                continue
            }
            var newText: String = currentText + genre
            
            if movie.genres.last != genre {
                newText += " | "
            }
            
            genreLabel.text = newText
        }
        
        guard let releaseDate = movie.releaseDate,
              let date = readFormatter.date(from: releaseDate) else {
            return
        }
        releaseDateLabel.text = "RELEASE_DATE".localized + releaseDate
        yearLabel.text = formatter.string(from: date)
    }
    
}

// MARK: - TopRatedViewProtocol

extension TopRatedViewController: TopRatedViewProtocol {
    
}

// MARK: - IndicatorInfoProvider

extension TopRatedViewController: CarouselDataSourceDelegate {
    
    func requestImage(forIndex index: Int) {
        if let posterPath = carouselData.data[safe: index]?.posterPath {
            DispatchQueue.global().sync {
                self.presenter?.imageNeededTrigger.onNext((index, posterPath))
            }
        }
    }
    
}
