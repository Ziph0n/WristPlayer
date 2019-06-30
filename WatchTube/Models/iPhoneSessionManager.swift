//
//  iPhoneSessionManager.swift
//  WatchTube
//
//  Created by Florian Hebrard on 29/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import Foundation
import WatchConnectivity
import MediaPlayer
import AVFoundation
import XCDYouTubeKit

class iPhoneSessionManager: NSObject, WCSessionDelegate {
    
    static let sharedManager = iPhoneSessionManager()
    
    var session: WCSession?
    
    func startSession() {
        if (WCSession.isSupported()) {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
       
        var replyValues = Dictionary<String, Any>()

        if let action = message["action"] as? String {
            if action == "getVideoURL" {
                let id = message["id"] as! String
                XCDYouTubeClient.default().getVideoWithIdentifier(id, completionHandler: { (video, error) in
                    if error == nil {
                        var videoURL = video?.streamURLs[XCDYouTubeVideoQuality.small240.rawValue]
                        if videoURL == nil {
                            videoURL = video?.streamURLs[XCDYouTubeVideoQuality.medium360.rawValue]
                        }
                        replyValues["videoURL"] = videoURL?.absoluteString
                        replyHandler(replyValues)
                    } else {
                        replyValues["error"] = error?.localizedDescription
                        replyHandler(replyValues)
                    }
                })
            }
        }
        
        //replyValues["status"] = "iphone" as AnyObject
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
