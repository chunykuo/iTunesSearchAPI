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
    func playing(error: Error)
}

class AudioPlayer: NSObject {
    static let sharedInstance = AudioPlayer()
    var player = AVPlayer()
    var nowPlayingTime: CMTime?
    @objc dynamic var isPlaying = false
    var delegate: AudioPlayerDelegate?
    private var observeToken: NSKeyValueObservation?
    
    private override init() {
        super.init()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(audioPlayEnd), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    func playNewAudioFor(url: URL) {
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
        player.seek(to: .zero)
        player.play()
        isPlaying = true
        
        self.player.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.new, .initial], context: nil)
        self.player.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options:[.new, .initial], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        let newStatus: AVPlayerItem.Status
        if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
            newStatus = AVPlayerItem.Status(rawValue: newStatusAsNumber.intValue)!
        } else {
            newStatus = .unknown
        }
        if let error = self.player.currentItem?.error, newStatus == .failed {
            print("Error: \(String(describing: error.localizedDescription))")
            delegate?.playing(error: error)
            delegate?.trackDidPlayToEnd()
        }
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
