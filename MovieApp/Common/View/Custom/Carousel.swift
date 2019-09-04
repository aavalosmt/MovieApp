//
//  Carousel.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/3/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol CarouselItem {
    associatedtype ItemDataType
    associatedtype ItemCellType: UICollectionViewCell
    
    static func reuseIdentifier() -> String
    func configureCellAtIndexPath(_ indexPath: IndexPath, item: ItemDataType) -> ItemCellType
    func willDisplayCellAtIndexPath(_ indexPath: IndexPath, item: ItemDataType)
    func updateCellImage(image: UIImage?)
}

enum HorizontalScrollDirection {
    case left
    case right
    case none
}

protocol CarouselDataSourceDelegate: class {
    func requestImage(forIndex index: Int)
}

class CarouselDataContainer<T> {
    var data: [T] = []
    
    init() {
        
    }
    
    init(data: [T]) {
        self.data = data
    }
}


class CarouselDataSource<T, U: CarouselItem> : NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout where T == U.ItemDataType {
    
    weak var delegate: CarouselDataSourceDelegate?
    
    let container: CarouselDataContainer<T>
    
    init(container: CarouselDataContainer<T>) {
        self.container = container
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return container.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = U.reuseIdentifier()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? U else {
            fatalError("Cells with reuse identifier \(reuseIdentifier) not of type \(U.ItemCellType.self)")
        }
        let item = container.data[indexPath.item]
        return cell.configureCellAtIndexPath(indexPath, item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? U else { return }
        let item = container.data[indexPath.item]
        cell.willDisplayCellAtIndexPath(indexPath, item: item)
        delegate?.requestImage(forIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let carouselLayout = collectionViewLayout as? CarouselCollectionViewLayout else {
            return UICollectionViewFlowLayout.automaticSize
        }
        
        if carouselLayout.itemSize.height > collectionView.bounds.size.height {
            let itemHeight = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom - carouselLayout.sectionInset.top - carouselLayout.sectionInset.bottom
            return CGSize(width: carouselLayout.itemSize.width, height: itemHeight)
        }
        return carouselLayout.itemSize
    }

}

protocol CarouselDelegate: class {
    func didFetchImage(for index: Int, image: UIImage?)
}

class Carousel<T, U: CarouselItem>: UICollectionView, CarouselDelegate where T == U.ItemDataType {
    
    private let carouselViewLayout = CarouselCollectionViewLayout()
    private let kItemSpacing: CGFloat = 10.0
    private let kItemWidthInset: CGFloat = 40.0
    
    var didPageChangedClosure: ((Int) -> Void)?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setUpCarousel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpCarousel()
    }
    
    private func setUpLayout(_ itemsQty: Int = 1) {
        contentInset = UIEdgeInsets(top: 0, left: itemsQty > 1 ? kItemSpacing : (kItemWidthInset / 2), bottom: 0, right: itemsQty > 1 ? kItemSpacing : (kItemWidthInset / 2))
        
        carouselViewLayout.scrollDirection = .horizontal
        carouselViewLayout.minimumInteritemSpacing = kItemSpacing
        carouselViewLayout.minimumLineSpacing = kItemSpacing
        
        let itemWidth = UIScreen.main.bounds.size.width / 2.0
        let itemHeight = self.bounds.height - self.contentInset.top - self.contentInset.bottom - carouselViewLayout.sectionInset.top - carouselViewLayout.sectionInset.bottom
        carouselViewLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        carouselViewLayout.didPageChangedClosure = didPageChangedClosure
        self.collectionViewLayout = carouselViewLayout
    }
    
    private func setUpCarousel() {
        self.backgroundColor = UIColor.white
        self.isPagingEnabled = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.bounces = false
        setUpLayout()
        self.register(UINib(nibName: U.reuseIdentifier(), bundle: nil), forCellWithReuseIdentifier: U.reuseIdentifier())
    }
    
    func setCarouselDataSource(_ dataSource: CarouselDataSource<T, U>) {
        self.dataSource = dataSource
        self.delegate = dataSource
        setUpLayout(dataSource.container.data.count)
        reloadData()
    }
    
    
    func didFetchImage(for index: Int, image: UIImage?) {
        if let cell = self.cellForItem(at: IndexPath(item: index, section: 0)) as? U {
            cell.updateCellImage(image: image)
        }
    }
}

public enum CarouselFlowLayoutSpacingMode {
    case fixed(spacing: CGFloat)
    case overlap(visibleOffset: CGFloat)
}

class CarouselCollectionViewLayout: UICollectionViewFlowLayout {
    
    fileprivate struct LayoutState {
        var size: CGSize
        var direction: UICollectionView.ScrollDirection
        func isEqual(_ otherState: LayoutState) -> Bool {
            return self.size.equalTo(otherState.size) && self.direction == otherState.direction
        }
    }
    
    @IBInspectable var sideItemScale: CGFloat = 0.7
    @IBInspectable var sideItemAlpha: CGFloat = 0.5
    @IBInspectable var sideItemShift: CGFloat = 1
    var spacingMode = CarouselFlowLayoutSpacingMode.fixed(spacing: 30)
    var didPageChangedClosure: ((Int) -> Void)?

    fileprivate var state = LayoutState(size: CGSize.zero, direction: .horizontal)
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        guard let collectionView = collectionView else {
            return
        }
        let currentState = LayoutState(size: collectionView.bounds.size, direction: self.scrollDirection)
        
        if !self.state.isEqual(currentState) {
            self.setupCollectionView()
            self.updateLayout()
            self.state = currentState
        }
    }
    
    fileprivate func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }
    
    fileprivate func updateLayout() {
        guard let collectionView = self.collectionView else { return }
        
        let collectionSize = collectionView.bounds.size
        let isHorizontal = (self.scrollDirection == .horizontal)
        
        let yInset = (collectionSize.height - self.itemSize.height) / 2
        let xInset = (collectionSize.width - self.itemSize.width) / 2
        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let side = isHorizontal ? self.itemSize.width : self.itemSize.height
        let scaledItemOffset = (side - side * self.sideItemScale) / 2
        switch self.spacingMode {
        case .fixed(let spacing):
            self.minimumLineSpacing = spacing - scaledItemOffset
        case .overlap(let visibleOffset):
            let fullSizeSideItemOverlap = visibleOffset + scaledItemOffset
            let inset = isHorizontal ? xInset : yInset
            self.minimumLineSpacing = inset - fullSizeSideItemOverlap
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }
    
    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        let isHorizontal = (self.scrollDirection == .horizontal)
        
        let collectionCenter = isHorizontal ? collectionView.frame.size.width / 2: collectionView.frame.size.height / 2
        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset
        
        let maxDistance = (isHorizontal ? self.itemSize.width : self.itemSize.height) + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance) / maxDistance
        
        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        
        let shift = (1 - ratio) * self.sideItemShift - 20.0
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(alpha * 10)
        
        if isHorizontal {
            attributes.center.y += shift
        } else {
            attributes.center.x += shift
        }
        
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView, !collectionView.isPagingEnabled, let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let isHorizontal = (self.scrollDirection == .horizontal)
        
        let midSide = (isHorizontal ? collectionView.bounds.size.width : collectionView.bounds.size.height) / 2
        let proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide
        
        var targetContentOffset: CGPoint
        if isHorizontal {
            let closest = layoutAttributes.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
            
            let page = Int((targetContentOffset.x  /
                collectionView.frame.size.width) * 2.0)
            didPageChangedClosure?(page)
        } else {
            let closest = layoutAttributes.sorted { abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midSide))
        }
        
        return targetContentOffset
    }
    
}
