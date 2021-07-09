//
//  BaseViewModel.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/7/9.
//

import Foundation

public class BaseViewModel {
    var errorString = Box(("", ""))
    
    func showError(title: String?, message: String) {
        self.errorString.value = (title ?? "Error", message)
    }
}
