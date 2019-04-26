//
//  HomeDetailsImageTableViewCell.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/26/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit

class HomeDetailsImageTableViewCell: UITableViewCell {

    public var images: [String] = [] {
        didSet {
            if !images.isEmpty {
                collection.reloadData()
                loadFirstImage(images[0])
            }
        }
    }
    private let imageCellId = "imageCellId"
    
    @IBOutlet weak private var imageVw: UIImageView!
    @IBOutlet weak private var collection: UICollectionView! {
        didSet {
            collection.delegate = self
            collection.dataSource = self
            collection.register(ImageCollectionCell.self, forCellWithReuseIdentifier: imageCellId)
        }
    }
    private func loadFirstImage(_ imageUrl: String) {
        NetworkLayer.loadImage(imageUrl) { [weak self] (data, error) in
            guard error == nil, let data = data, let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                strongSelf.imageVw.image = image
            }
        }
    }
}

extension HomeDetailsImageTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionCell {
            imageVw.image = cell.imageView.image
        }
    }
}

extension HomeDetailsImageTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as? ImageCollectionCell else { return UICollectionViewCell() }
        cell.imageURL = images[indexPath.row]
        return cell
    }
}

extension HomeDetailsImageTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/3 - 6, height: frame.width/3 - 6)
    }
}
