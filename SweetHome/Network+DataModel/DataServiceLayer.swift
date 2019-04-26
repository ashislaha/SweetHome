//
//  DataServiceLayer.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/17/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import Foundation

struct Constants {
    struct DataService {
        static let flickrEndPoint = "https://api.flickr.com/services/rest/"
    }
}

// MARK:- DataSourceError
enum DataSourceError: Error {
    case InvalidURL
    case CategoriesGenererationError
    case ErrorInServerData
}

final class DataServiceProvider {
    
    private let defaultParams: [String: String] = [
        "method": "flickr.photos.search",
        "api_key": "3e7cc266ae2b0e0d78e279ce8e361736",
        "format": "json",
        "safe_search": "1",
        "nojsoncallback": "1"
    ]
    
    private func getUrl(_ params: [String: String]) -> String {
        var endPoint = Constants.DataService.flickrEndPoint + "?"
        defaultParams.forEach {
            endPoint += $0 + "=" + $1 + "&"
        }
        params.forEach {
            endPoint += $0 + "=" + $1 + "&"
        }
        endPoint.removeLast() // remove the last extra "&"
        return endPoint
    }
    
    // get photos (using JSONDecoder)
    func getPhotos(params: [String: String], completionHandler: @escaping (([Photo])->())) throws {
        let endPointUrl = getUrl(params)
        guard let url = URL(string: endPointUrl) else { throw DataSourceError.InvalidURL }
        
        NetworkLayer.getRawData(url: url, successBlock: { (data) in
            guard let data = data as? Data else { return }
            do {
                let photosModel = try JSONDecoder().decode(PhotosModel.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(photosModel.photosMetaData.photo)
                }
            } catch let error {
                print(error)
                completionHandler([])
            }
        }) { (error) in
            // handle error if needed
        }
    }
    
    // get Home details
    func getHomeDetails(completionBlock : @escaping (HomeDetails)->()) {
        guard let path = Bundle.main.url(forResource: "homeDetails", withExtension: "json"), let data = try? Data(contentsOf: path) else { return }
        guard let homeDetails = try? JSONDecoder().decode(HomeDetails.self, from: data) else { return }
        completionBlock(homeDetails)
    }
}
