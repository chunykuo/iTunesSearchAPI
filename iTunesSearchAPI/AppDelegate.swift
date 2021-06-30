//
//  AppDelegate.swift
//  iTunesSearchAPI
//
//  Created by David Kuo on 2021/6/28.
//

import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /* AudioSession set */
        let audioSession = AVAudioSession.sharedInstance()
        do
        {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        }
        catch
        {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        return true
    }
}

