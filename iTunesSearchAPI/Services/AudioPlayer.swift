//
//  AudioPlayer.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/6/28.
//

import Foundation
import AVKit

class AudioPlayer {
    static let sharedInstance = AudioPlayer()
    private init() {}
    var player = AVPlayer()
    
    func playAudioFor(url: URL) {
        player = AVPlayer(url: url)
        player.seek(to: .zero)
        player.play()
    }
}
