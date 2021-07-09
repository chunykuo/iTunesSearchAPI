//
//  TrackListCellViewModel.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/7/6.
//

import UIKit.UIImage

public class TrackListCellViewModel {
    let track: Box<Music?> = Box(nil)
    let image: Box<UIImage?> = Box(nil)
    let title = Box(" ")
    let imageUrl = Box(" ")
    
    private let downloadImageQueue = OperationQueue()
    
    func getImagesFrom(url: String) {
        downloadImageQueue.addOperation { [weak self] in
            let baseService = BaseService()
            baseService.getImageFrom(url: url) { [weak self] data in
                self?.image.value = UIImage(data: data)
            } failure: { error in
                print(error)
                self?.image.value = nil
            }
        }
    }
}
