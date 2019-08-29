//
//  ImageCaching.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/28/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol ImageCaching {
    func saveImage(image: UIImage?, url: URL)
    func imageWithUrl(url: URL?) -> UIImage?
}

class ImageCache: ImageCaching {
    
    static let shared: ImageCache = ImageCache()
    
    private var cache = NSCache<NSString, UIImage>()
    
    func saveImage(image: UIImage?, url: URL) {
        guard let image = image else { return }
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
    func imageWithUrl(url: URL?) -> UIImage? {
        guard let path = url?.absoluteString else {
            return nil
        }
        return cache.object(forKey: path as NSString)
    }
    
}
