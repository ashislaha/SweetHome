//
//  UserPreferanceView.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/17/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit

protocol UserPreferanceViewProtocol: class {
    func optionSelected(_ option: Options)
}

enum Options: String {
    case collection = "Collection"
    case myHouse = "My House"
    case duplicate = "Duplicates"
    case missing = "Missing"
    case favourites = "Favourites"
}

class UserPreferanceView: UIView {
    
    private let options: [Options] = [.collection, .myHouse, .duplicate, .missing, .favourites]
    private let cellId = "cellId"
    private var collectionView: UICollectionView!
    
    public weak var delegate: UserPreferanceViewProtocol?
    
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
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.isScrollEnabled = true
    }
}

extension UserPreferanceView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TextCell {
            cell.updateColor(selected: true)
        }
        delegate?.optionSelected(options[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TextCell {
            cell.updateColor(selected: false)
        }
    }
}

extension UserPreferanceView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TextCell else { return UICollectionViewCell() }
        cell.text = options[indexPath.row].rawValue
        if options[indexPath.row] == .collection {
            cell.updateColor(selected: true)
        }
        return cell
    }
}

extension UserPreferanceView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}


