//
//  MusicViewModelTests.swift
//  iTunesSearchAPITests
//
//  Created by David Kuo on 2021/7/15.
//

import XCTest
@testable import iTunesSearchAPI

class MusicViewModelTests: XCTestCase {
    let testMusic = Music(trackName: "Holy", artistName: "Justin Bieber",
                          previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/90/62/0e/90620e71-a31c-f0c9-78e4-4b306f8d9ab1/mzaf_15860839629185804460.plus.aac.p.m4a",
                          artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/6d/78/65/6d786571-271b-3fb0-9612-05162bb6b5ae/source/100x100bb.jpg")
    var viewModel = MusicViewModel()
    
    func testTrackCanPlay() {
        let expectation = self.expectation(description: "Play a track")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.viewModel.playFrom(track: self.testMusic)
            if self.viewModel.isPlaying.value && !self.viewModel.playingTrackTitle.value.isEmpty {
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 7, handler: nil)
    }
}
