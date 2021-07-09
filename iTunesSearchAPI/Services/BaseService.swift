//
//  BaseService.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/6/28.
//

import Foundation

enum BaseServiceError: Error {
    case failedRequest
    case invalidResponse
    case emptyData
    case notFoundUrl
}

class BaseService {    
    func getApiFrom(urlComponents: URLComponents, success: @escaping (Data) -> (), failure: @escaping (BaseServiceError) -> ()) {
        if let url = urlComponents.url {
            // for test error
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 3
            
            let urlSession = URLSession(configuration: config)
            urlSession.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    guard error == nil else {
                        failure(.failedRequest)
                        return
                    }
                    
                    guard response != nil else {
                        failure(.invalidResponse)
                        return
                    }
                    
                    guard let data = data else {
                        failure(.emptyData)
                        return
                    }
                    success(data)
                }
            }.resume()
        } else {
            failure(.notFoundUrl)
        }
    }
    
    func getImageFrom(url: String, success: ((Data) -> ())?, failure: @escaping (BaseServiceError) -> ()) {
        if let imageURL = URL(string: url) {
            URLSession.shared.dataTask(with: imageURL) { data , response, error in
                guard error == nil else {
                    failure(.failedRequest)
                    return
                }

                guard response != nil else {
                    failure(.invalidResponse)
                    return
                }

                guard let data = data else {
                    failure(.emptyData)
                    return
                }
                success!(data)
            }.resume()
        } else {
            failure(.notFoundUrl)
        }
    }
}
