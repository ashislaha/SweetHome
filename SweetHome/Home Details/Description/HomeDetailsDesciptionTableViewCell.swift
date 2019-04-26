//
//  HomeDetailsDesciptionTableViewCell.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/26/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit

class HomeDetailsDesciptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var details: UILabel!
    public var desc: String? {
        didSet {
            details.text = desc
        }
    }
}
