//
//  MusicViewModel.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/6/29.
//

import Foundation

public class MusicViewModel {
    private let player = AudioPlayer.sharedInstance
    let playingTrack: Box<Music?> = Box(nil)
    let trackOfList: Box<[Music?]> = Box([])
    let trackTitle = Box(" ")
    
    func getSearchResultListFrom(keyword: String, finish: @escaping () -> Void) {
        let searchAPI = iTunesService()
        searchAPI.searchMusic(for: keyword) { music in
            self.trackOfList.value = []
            self.trackOfList.value = music
            finish()
        } failure: { error in
            print(error)
        }
    }
    
    func playFrom(track: Music) {
        if let validURL = URL(string: track.previewUrl) {
            player.playAudioFor(url: validURL)
            playingTrack.value = track
            trackTitle.value = track.artistName + " - " + track.trackName
        }
    }
}
