//
//  BaseService.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/6/28.
//

import Foundation

enum BaseServiceError: String {
    case failedRequest = "Failed Request"
    case invalidResponse = "Invalid Response"
    case emptyData = "Empty Data"
}

class BaseService {
    private let scheme = "https"
    private let host = "itunes.apple.com"
    private let path = "/search"
    
    func getApiFromItunes(params: [URLQueryItem], success: @escaping (Data) -> (), failure: @escaping (BaseServiceError) -> ()) {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = path
        urlComponent.queryItems = params
        let url = urlComponent.url!
        URLSession.shared.dataTask(with: url) { data, response, error in
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
    }
}
