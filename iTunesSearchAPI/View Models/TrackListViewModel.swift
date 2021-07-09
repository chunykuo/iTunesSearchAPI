//
//  TrackListViewModel.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/7/7.
//

import Foundation

public class TrackListViewModel: BaseViewModel {
    let trackList: Box<[TrackListCellViewModel?]> = Box([])
    var numberOfCell: Int {
        return trackList.value.count
    }
    
    func getSearchResultListFrom(keyword: String, success: @escaping () -> Void) {
        let searchAPI = ItunesService()
        searchAPI.searchMusic(for: keyword) { [weak self] music in
            self?.trackList.value = []
            for track in music {
                let cell = TrackListCellViewModel()
                cell.title.value = track.trackName
                cell.imageUrl.value = track.artworkUrl100
                cell.track.value = track
                self?.trackList.value.append(cell)
            }
            success()
        } failure: { error in
            switch error {
            case .emptyData:
                self.showError(title: "Result not found", message: error.localizedDescription)
            default:
                self.showError(title: error.rawValue, message: error.localizedDescription)
            }
        }
    }
}
