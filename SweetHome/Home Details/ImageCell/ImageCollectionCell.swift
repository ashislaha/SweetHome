//
//  ImageCollectionCell.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/26/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    // add a NSCache for caching the images
    let cacheImages = NSCache<NSString, DiscardableImageCacheItem>()
    
    public var imageURL: String? {
        didSet {
            updateUI()
        }
    }
    
    // view loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // clean the collection view cell before reuse
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: Layout Setup
    private func viewSetup() {
        addSubview(imageView)
        backgroundColor = .white
        imageView.anchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    // MARK: Update UI
    private func updateUI() {
        guard let imageURL = imageURL else { return }
        // check whether the image is present into cache or not
        if let cacheItem = cacheImages.object(forKey: NSString(string: imageURL)) {
            imageView.image = cacheItem.image
        } else {
            NetworkLayer.loadImage(imageURL) { [weak self] (data, error) in
                guard error == nil, let data = data, let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else { return }
                    strongSelf.cacheImages.setObject(DiscardableImageCacheItem(image: image), forKey: NSString(string: imageURL)) // setting into cache
                    strongSelf.imageView.image = image
                }
            }
        }
    }
}
