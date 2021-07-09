//
//  iTunesService.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/6/28.
//

import Foundation

class ItunesService: BaseService {
    private let scheme = "https"
    private let host = "itunes.apple.com"
    private let searchPath = "/search"
    
    func searchMusic(for keyword: String, success: @escaping ([Music])->(), failure:  @escaping (BaseServiceError)->()) {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = searchPath
        urlComponent.queryItems = [URLQueryItem(name: "media", value: "music"),
                          URLQueryItem(name: "term", value: keyword)]
        getApiFrom(urlComponents: urlComponent) { data in
            do {                
                let decoder = JSONDecoder()
                let resultData = try decoder.decode(SearchResult.self, from: data)
                if resultData.results.count > 0 {
                    success(resultData.results)
                } else {
                    failure(.emptyData)
                }
            } catch {
                failure(error as? BaseServiceError ?? .failedRequest)
            }
        } failure: { error in
            failure(error)
        }
    }
}
