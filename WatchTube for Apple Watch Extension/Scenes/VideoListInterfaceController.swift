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

class VideoListInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var videoTableRow: WKInterfaceTable!
    
    var videos: [Video]!
    var session: WCSession!
    var timer: DispatchSourceTimer?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        videos = context as! [Video]
        
        self.setupTable()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
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
        let applicationData = ["action": "start",
                               "id": videos[rowIndex].id]
        session.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
        
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: 1.0)
            
        timer?.setEventHandler { [weak self] in
            self?.keepalive()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let action = message["action"] as? String {
            if action == "stop" {
                timer?.suspend()
            }
            if action == "start" {
                timer?.resume()
            }
        }
        
        var replyValues = Dictionary<String, AnyObject>()
        replyValues["status"] = "watch" as AnyObject
        replyHandler(replyValues)
    }
    
    @objc func keepalive() {
        let applicationData = ["action": "keepalive"]
        session.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }
}
