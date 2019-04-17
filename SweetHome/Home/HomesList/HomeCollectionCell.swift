//
//  HomeCollectionCell.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/17/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit

class HomeCollectionCell: UICollectionViewCell {
    
    // add a NSCache for caching the images
    let cacheImages = NSCache<NSString, DiscardableImageCacheItem>()
    
    public var photo: Photo? {
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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 2.5
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
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
        guard let photo = photo else { return }
        
        // construct the image url
        // http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
        // example http://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg
        
        let imageUrl = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        loadImage(imageUrl)
    }
    
    // MARK: loadImage
    private func loadImage(_ imageUrl: String) {
        guard !imageUrl.isEmpty, let url = URL(string: imageUrl) else { return }
        
        // check whether the image is present into cache or not
        if let cacheItem = cacheImages.object(forKey: NSString(string: imageUrl)) {
            imageView.image = cacheItem.image
        } else {
            let session = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let data = data , error == nil else { return }
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else { return }
                    self?.cacheImages.setObject(DiscardableImageCacheItem(image: image), forKey: NSString(string: imageUrl)) // setting into cache
                    self?.imageView.image = image
                }
            }
            session.resume()
        }
    }
}
