//
//  TextCell.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/17/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit

class TextCell: UICollectionViewCell {
    
    public var text: String? {
        didSet {
            textLabel.text = text
            textLabel.textColor = .darkGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetUp()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewSetUp()
    }
    
    // text
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        return label
    }()
    
    private func viewSetUp() {
        addSubview(textLabel)
        textLabel.fillSuperView()
    }
    
    public func updateColor(selected: Bool) {
        textLabel.textColor = selected ? .tintBlueColor: .darkGray
    }
}
