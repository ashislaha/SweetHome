//
//  DataModel.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/17/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import Foundation

// Photos
struct PhotosModel: Decodable {
    let photosMetaData: PhotosMetaData
    
    private enum CodingKeys : String, CodingKey {
        case photosMetaData = "photos"
    }
}

struct PhotosMetaData: Decodable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [Photo]
}

// Photo
struct Photo: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPublic: Int
    let isFriend: Int
    let isFamily: Int
    
    private enum CodingKeys : String, CodingKey {
        case id, owner, secret, server, farm, title, isPublic = "ispublic", isFriend = "isfriend", isFamily = "isfamily"
    }
}

// Will use for future purpose
struct Home: Decodable {
    let id: String
    let imageUrl: String
    let title: String
    let desciption: String
}
