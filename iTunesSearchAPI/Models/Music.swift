//
//  Music.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/6/28.
//

import Foundation

struct Music: Codable {
    let trackName: String
    let artistName: String
    let previewUrl: String
}

struct SearchResult: Codable {
    let resultCount: Int
    let results: [Music]
}
