//
//  PlaylistListInterfaceController.swift
//  WatchTube for Apple Watch Extension
//
//  Created by Florian Hebrard on 30/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import UIKit

class PlaylistListInterfaceController: WKInterfaceController {
    
    @IBOutlet var playlistTableRow: WKInterfaceTable!
    @IBOutlet var activityImage: WKInterfaceImage!
    @IBOutlet var notLoggedInLabel: WKInterfaceLabel!
    
    var playlists: [Playlist]!
    var timer: Timer!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        WatchSessionManager.sharedManager.wakeUpiPhone()

        self.activityImage.setImageNamed("Activity")
        self.activityImage.startAnimatingWithImages(in: NSRange(location: 0, length: 30), duration: 1.0, repeatCount: 0)
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.checkAccessToken), userInfo: nil, repeats: true)
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @objc func checkAccessToken() {
        if User.accessTokenRefreshed {
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            self.getPlaylists()
        }
        if User.userLoggedIn == "false" {
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            self.activityImage.setHidden(true)
            self.notLoggedInLabel.setHidden(false)
        }
    }
    
    func getPlaylists() {
        Playlist.getUserPlaylists() { playlists in
            self.playlists = playlists
            self.setupTable()
            self.activityImage.setHidden(true)
            self.playlistTableRow.setHidden(false)
        }
    }
    
    func setupTable() {
        playlistTableRow.setNumberOfRows(playlists.count, withRowType: "PlaylistRow")
        
        for i in 0 ..< playlists.count {
            if let row = playlistTableRow.rowController(at: i) as? PlaylistRow {
                row.titleLabel.setText(playlists[i].title)
                row.playlistId = playlists[i].id
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let context = ["action": "playlist",
                       "playlistId": playlists[rowIndex].id]
        self.pushController(withName: "VideoListInterfaceController", context: context)
    }
}
