//
//  GenreTableViewCell.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    
    private let kSpacing: CGFloat = 20.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var genres: [Genre] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configureCollectionView()
    }
    
    func configure(withGenres genres: [Genre]) {
        self.genres = genres
        collectionView.reloadData()
        contentView.layoutIfNeeded()
    }
    
}

extension GenreTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func configureCollectionView() {
        collectionView.register(identifier: GenreCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let genre = genres[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(withGenre: genre)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width / 2.0) - (25.0)
        return CGSize(width: width, height: width / 2.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kSpacing * 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kSpacing
    }
    
}
