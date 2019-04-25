//
//  NetworkLayer.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/17/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import Foundation

// data request type
enum NetworkRequest: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

typealias successBlock = ((Any?) -> Void)
typealias failureBlock = ((Any?) -> Void)

final class NetworkLayer {
    // "GET"
    class func getDictionaryData(url: URL, successBlock: successBlock?, failed failureBlock: failureBlock? ) {
        
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data, error == nil {
                guard let response = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else { return }
                // call back in back-ground thread, so please update UI elements in main-thread while computing
                successBlock?(response)
            } else {
                failureBlock?(error)
            }
        }
        session.resume()
    }
    
    class func getRawData(url: URL, successBlock: successBlock?, failed failureBlock: failureBlock? ) {
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                successBlock?(data)
            } else {
                failureBlock?(error)
            }
        }
        session.resume()
    }
    
    // "POST"/"PUT"/"DELETE"
    class func postData(urlString: String, bodyDict: [String: Any], requestType: NetworkRequest, successBlock: successBlock?, failureBlock: failureBlock?) {
        
        // validation
        guard let url = URL(string: urlString), !urlString.isEmpty else { return }
        // request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // body
        let body = requestType == .DELETE ? [:] : bodyDict
        guard let data = getJsonDataFromDictionary(jsonDict: body) else { return }
        // session
        let session = URLSession.shared.uploadTask(with: urlRequest, from: data) { (data, response, error) in
            
            if let data = data, error == nil { // success
                guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else { return }
                // call back in back-ground thread, so please update UI elements in main-thread while computing
                successBlock?(responseJSON)
            } else { // failure
                failureBlock?(error)
            }
        }
        session.resume()
    }
}

// MARK:- Private Extension of Network Layer
private extension NetworkLayer {
    class func getJsonDataFromDictionary(jsonDict httpBody: [String: Any]?) -> Data? {
        var bodyData: Data? = nil
        if let httpBody = httpBody {
            bodyData = try? JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        }
        return bodyData
    }
}

// MARK:- loadImage
extension NetworkLayer {
    class func loadImage(_ imageUrl: String, completionBlock: @escaping (Data?, Error?) -> ()) {
        guard !imageUrl.isEmpty, let url = URL(string: imageUrl) else {
            completionBlock(nil, nil)
            return
        }
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data , error == nil else {
                completionBlock(nil, error)
                return
            }
            completionBlock(data, nil)
        }
        session.resume()
    }
}


