//
//  HomeDetailsModel.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/26/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import Foundation

struct HomeDetails: Decodable {
    let images: [String]
    let description: String
    let videoUrl: String
}
