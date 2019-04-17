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
    }
}

// MARK:- DataSourceError
enum DataSourceError: Error {
    case InvalidURL
    case CategoriesGenererationError
    case ErrorInServerData
}

struct Home: Decodable {
    let id: String
    let imageUrl: String
    let title: String
    let desciption: String
}

final class DataServiceProvider {
    
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
