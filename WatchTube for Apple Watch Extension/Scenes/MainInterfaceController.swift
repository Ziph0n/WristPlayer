//
//  MainInterfaceController.swift
//  WatchTube for Apple Watch Extension
//
//  Created by Florian Hebrard on 28/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import Foundation
import WatchKit
import Alamofire

class MainInterfaceController: WKInterfaceController {
    
    @IBAction func searchVideoButtonTapped() {
        
        let keywordsHistory = UserDefaults.standard.stringArray(forKey: preferencesKeys.keywordsHistory) ?? [String]()
        var lastTwentyKeywordsHistory = Array(keywordsHistory.suffix(20))
        if lastTwentyKeywordsHistory.count == 0 {
            lastTwentyKeywordsHistory.append("Tove Lo")
        }
        
        self.presentTextInputController(withSuggestions: lastTwentyKeywordsHistory.reversed(), allowedInputMode: .plain) { (keywords) in
            if let keyword = keywords as? [String] {
                if keyword.count > 0 {
                    lastTwentyKeywordsHistory.append(keyword[0])
                    UserDefaults.standard.set(lastTwentyKeywordsHistory, forKey: preferencesKeys.keywordsHistory)
                    let context = ["action": "search",
                                   "query": keyword[0]]
                    self.pushController(withName: "VideoListInterfaceController", context: context)
                }
            }
        }
    }
    
    @IBAction func nowPlayingButtonTapped() {
        self.pushController(withName: "NowPlayingInterfaceController", context: nil)
    }
    
    @IBAction func myPlaylistsButtonTapped() {
        self.pushController(withName: "PlaylistListInterfaceController", context: nil)
    }
    
}
