//
//  HomesView.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/17/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit

protocol HomesViewProtocol: class {
    func selectHome(_ id: String)
}


class HomesView: UIView {
    
    private let cellId = "cellId"
    private var collectionView: UICollectionView!
    
    public weak var delegate: HomesViewProtocol?
    public var photos: [Photo] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionViewSetUp()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewSetUp()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // MARK:- setup collectionView
    private func collectionViewSetUp() {
        let layout =  UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.isScrollEnabled = true
    }
}

extension HomesView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomeCollectionCell else { return UICollectionViewCell() }
        cell.photo = photos[indexPath.row]
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension HomesView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // initialise the details of photo if needed
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomesView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/3 - 6, height: frame.width/3 - 6)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}




