//
//  ViewController.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/6/28.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playingLabel: UILabel!
    @IBOutlet weak var playingImageView: UIImageView!
    
    private let playingViewModel = MusicViewModel()
    private let trackListViewModel = TrackListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "iTunes Music Search"
        playingViewDataBinding()
        trackListViewDataBinding()
    }
    
    @objc func playAndPauseButtonPress() {
        playingViewModel.continueOrResumePlay()
    }
    
    func playingViewDataBinding() {
        playingViewModel.playingTrackTitle.bind { [weak self] title in
            self?.playingLabel.text = title
        }
        playingViewModel.playingTrackImage.bind { [weak self] image in
            self?.playingImageView.image = image
        }
        playingViewModel.isPlaying.bind { [weak self] isPlaying in
            if isPlaying {
                let barButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(self?.playAndPauseButtonPress))
                self?.navigationItem.rightBarButtonItem = barButton
            } else {
                let barButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(self?.playAndPauseButtonPress))
                self?.navigationItem.rightBarButtonItem = barButton
            }
        }
        playingViewModel.errorString.bind { [weak self] title, message in
            if !message.isEmpty {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func trackListViewDataBinding() {
        trackListViewModel.errorString.bind { [weak self] title, message in
            if !message.isEmpty {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let keyword = searchBar.text, keyword != "" else {
            return
        }
        trackListViewModel.getSearchResultListFrom(keyword: keyword) {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackListViewModel.numberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TrackTableViewCell else {
            fatalError("Not found cell")
        }
        if let rowViewModel = trackListViewModel.trackList.value[indexPath.row] {
            cell.setupDataBind(viewModel: rowViewModel)
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackIndexPath = trackListViewModel.trackList.value[indexPath.row]
        if let track = trackIndexPath?.track.value {
            playingViewModel.playFrom(track: track)
        }
    }
}
