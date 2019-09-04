//
//  ImageCaching.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol ImageCaching {
    func saveImage(image: UIImage?, url: URL, size: ImageSize)
    func imageWithUrl(url: URL?, size: ImageSize) -> UIImage?
}

class ImageCache: ImageCaching {
    
    static let shared: ImageCache = ImageCache()
    
    private var cache = NSCache<NSString, UIImage>()
    
    func saveImage(image: UIImage?, url: URL, size: ImageSize) {
        guard let image = image else { return }
        cache.setObject(image, forKey: url.absoluteString.appending("_" + size.rawValue) as NSString)
    }
    
    func imageWithUrl(url: URL?, size: ImageSize) -> UIImage? {
        guard let path = url?.absoluteString.appending("_" + size.rawValue) else {
            return nil
        }
        return cache.object(forKey: path as NSString)
    }
    
}
