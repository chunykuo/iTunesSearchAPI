//
//  MusicViewModel.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/6/29.
//

import UIKit.UIImage

public class MusicViewModel {
    private let player = AudioPlayer.sharedInstance
    private var observeToken: NSKeyValueObservation?
    let playingTrackTitle = Box(" ")
    let playingTrackImage: Box<UIImage?> = Box(nil)
    var isPlaying: Box<Bool> = Box(false)
    
    init() {
        player.delegate = self
        observeToken = player.observe(\.isPlaying, options: [.new]) { [weak self] player, change in
            if let newValue = change.newValue {
                self?.isPlaying.value = newValue
            }
        }
    }
    
    func playFrom(track: Music) {
        if let validURL = URL(string: track.previewUrl) {
            player.playNewAudioFor(url: validURL)
            playingTrackTitle.value = track.artistName + " - " + track.trackName
        }
        fetchImageFrom(track: track)
    }
    
    func continueOrResumePlay() {
        if player.isPlaying {
            player.pause()
        } else {
            player.resumePlaying()
        }
    }
    
    func fetchImageFrom(track: Music) {
        playingTrackImage.value = nil
        let validURL = track.artworkUrl100
        let baseAPI = BaseService()
        baseAPI.getImageFrom(url: validURL) { data in
            DispatchQueue.main.async {
                self.playingTrackImage.value = UIImage(data: data)
            }
        } failure: { error in
            print(error)
        }
    }
}

extension MusicViewModel: AudioPlayerDelegate {
    func trackDidPlayToEnd() {
        self.playingTrackTitle.value = ""
        self.playingTrackImage.value = nil
    }
}
