//
//  VideoListInterfaceController.swift
//  WatchTube for Apple Watch Extension
//
//  Created by Florian Hebrard on 28/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import UIKit

class VideoListInterfaceController: WKInterfaceController {

    @IBOutlet var videoTableRow: WKInterfaceTable!
    @IBOutlet var activityImage: WKInterfaceImage!
    
    var videos: [Video]!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.activityImage.setImageNamed("Activity")
        self.activityImage.startAnimatingWithImages(in: NSRange(location: 0, length: 30), duration: 1.0, repeatCount: 0)
        
        
        if let dictionary = context as? Dictionary<String, Any> {
            if let action = dictionary["action"] as? String {
                if action == "search" {
                    let keyword = dictionary["query"] as! String
                    Video.getVideos(keyword: keyword) { videos in
                        self.videos = videos
                        self.setupTable()
                        self.activityImage.setHidden(true)
                        self.videoTableRow.setHidden(false)
                    }
                }
                if action == "playlist" {
                    let playlistId = dictionary["playlistId"] as! String
                    Video.getPlaylistVideos(playlistId: playlistId) { videos in
                        self.videos = videos
                        self.setupTable()
                        self.activityImage.setHidden(true)
                        self.videoTableRow.setHidden(false)
                    }
                }
            }
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

    func setupTable() {
        videoTableRow.setNumberOfRows(videos.count, withRowType: "VideoRow")
        
        for i in 0 ..< videos.count {
            if let row = videoTableRow.rowController(at: i) as? VideoRow {
                row.titleLabel.setText(videos[i].title)
                row.videoId = videos[i].id
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
            //WatchSessionManager.sharedManager.startVideo(id: self.videos[rowIndex].id)
        self.pushController(withName: "StartStopInterfaceController", context: self.videos[rowIndex])
    }
}
