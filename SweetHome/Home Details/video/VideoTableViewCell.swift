//
//  VideoTableViewCell.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/26/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit
import WebKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var webView: WKWebView!
    public var videoUrl: String? {
        didSet {
            if let videoUrl = videoUrl, let url = URL(string: videoUrl) {
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        }
    }
}
