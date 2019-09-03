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
    
    @IBOutlet weak var carouselContainer: UIView!
    
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
    
    // MARK: - Private methods
    
    private func bind() {
        presenter?
            .moviesChanged
            .emit(onNext: { [weak self] results in
                guard let self = self else { return }
                self.carouselData.data.append(contentsOf: results)
                
                DispatchQueue.main.async {
                    self.carousel.reloadData()
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
        
        let layout = CarouselCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.carousel = Carousel<Movie, CarouselMovieCollectionViewCell>(
            frame: CGRect(x: 0, y: 0, width: carouselContainer.frame.width, height: carouselContainer.frame.height),
            collectionViewLayout: layout)
        self.carousel.setCarouselDataSource(carouselDataSource)
        
        self.carousel.backgroundColor = UIColor.clear
        self.carousel.reloadData()
        
        carouselContainer.addSubview(self.carousel)
        carouselContainer.layoutIfNeeded()
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
