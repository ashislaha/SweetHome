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
        static let endPoint = "https://google.com"
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
    
    // get photos (using JSONDecoder)
    func getPhotos(params: [String: String], completionHandler: @escaping (([Photo])->())) throws {
        let endPointUrl = getUrl(params)
        guard let url = URL(string: endPointUrl) else { throw DataSourceError.InvalidURL }
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let photosModel = try JSONDecoder().decode(PhotosModel.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(photosModel.photosMetaData.photo)
                }
            } catch let error {
                print(error)
                completionHandler([])
            }
        }
        session.resume()
    }
    
    private func getUrl(_ params: [String: String]) -> String { // input params is text & page like text = kittens, page = 2
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
    
    // get single home (using JSONDecoder)
    func getHome(completionHandler: @escaping ((Home)->())) throws {
        let categoriesEndPoint = Constants.DataService.endPoint + "/home.json"
        guard let url = URL(string: categoriesEndPoint) else { throw DataSourceError.InvalidURL }
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            guard let categories = try? JSONDecoder().decode(Home.self, from: data) else { return }
            DispatchQueue.main.async {
                completionHandler(categories)
            }
        }
        session.resume()
    }
    
    // get all homes details
    func getAllHomes(productId: String, completionHandler: @escaping (([Home])->())) throws {
        let urlStr = Constants.DataService.endPoint + "/allHomes.json"
        guard let url = URL(string: urlStr), !urlStr.isEmpty else { throw DataSourceError.InvalidURL }
        
        NetworkLayer.getData(url: url, successBlock: { (response) in
            // success
            DispatchQueue.main.async {
                guard let response = response as? [String: Any] else { return }
                completionHandler([])
            }
        }) { (error) in
            print(error.debugDescription)
        }
    }
}
