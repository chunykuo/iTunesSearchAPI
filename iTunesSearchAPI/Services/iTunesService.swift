//
//  iTunesService.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/6/28.
//

import Foundation

class iTunesService: BaseService {    
    func searchMusic(for keyword: String, success: @escaping ([Music])->(), failure:  @escaping (String)->()) {
        let queryItems = [URLQueryItem(name: "media", value: "music"),
                          URLQueryItem(name: "term", value: keyword)]
        getApiFromItunes(params: queryItems) { data in
            do {                
                let decoder = JSONDecoder()
                let resultData = try decoder.decode(SearchResult.self, from: data)
                success(resultData.results)
            } catch {
                failure(error.localizedDescription)
            }
        } failure: { error in
            failure(error.rawValue)
        }
    }
}
