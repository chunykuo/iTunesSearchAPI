//
//  AudioPlayer.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/6/28.
//

import Foundation
import AVKit

protocol AudioPlayerDelegate {
    func trackDidPlayToEnd()
}

class AudioPlayer: NSObject {
    static let sharedInstance = AudioPlayer()
    var player = AVPlayer()
    var nowPlayingTime: CMTime?
    @objc dynamic var isPlaying = false
    var delegate: AudioPlayerDelegate?
    
    private override init() {
        super.init()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(audioPlayEnd), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    func playNewAudioFor(url: URL) {
        player = AVPlayer(url: url)
        player.seek(to: .zero)
        player.play()
        isPlaying = true
    }
    
    func pause() {
        player.pause()
        nowPlayingTime = player.currentTime()
        isPlaying = false
    }
    
    func resumePlaying() {
        if let time = nowPlayingTime {
            player.seek(to: time)
        }
        player.play()
        isPlaying = true
    }
    
    @objc func audioPlayEnd() {
        isPlaying = false
        nowPlayingTime = nil
        delegate?.trackDidPlayToEnd()
    }
}
