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
    
    private let viewModel = MusicViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        title = "iTunes Music Search"
        viewModel.trackTitle.bind { [weak self] title in
            self?.playingLabel.text = title
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let keyword = searchBar.text, keyword != "" else {
            return
        }
        viewModel.getSearchResultListFrom(keyword: keyword) {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trackOfList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let viewModelData = viewModel.trackOfList.value[indexPath.row]
        cell.textLabel?.text = viewModelData?.trackName
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let music = viewModel.trackOfList.value[indexPath.row] {
            viewModel.playFrom(track: music)
        }
    }
}
