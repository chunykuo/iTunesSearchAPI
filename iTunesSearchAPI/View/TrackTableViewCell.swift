//
//  TrackTableViewCell.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/7/6.
//

import UIKit.UITableViewCell

class TrackTableViewCell: UITableViewCell {
    func setupDataBind(viewModel: TrackListCellViewModel) {
        viewModel.title.bind { [weak self] title in
            self?.textLabel?.text = title
        }
        
        viewModel.imageUrl.bind { [weak self] url in
            viewModel.getImagesFrom(url: viewModel.imageUrl.value)
            viewModel.image.bind { [weak self] image in
                DispatchQueue.main.async {
                    self?.imageView?.image = image
                    self?.setNeedsLayout()
                }
            }
        }
    }
}
