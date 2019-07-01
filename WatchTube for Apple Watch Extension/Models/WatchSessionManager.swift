//
//  WatchSessionManager.swift
//  WatchTube for Apple Watch Extension
//
//  Created by Florian Hebrard on 29/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let sharedManager = WatchSessionManager()

    var session: WCSession?
    
    func startSession() {
        
        if (WCSession.isSupported()) {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func getVideoURL(id: String, completion: @escaping (String) -> ()) {
        let applicationData =  ["action": "getVideoURL",
                                "id": id]
        session?.sendMessage(applicationData, replyHandler: { (data) in
            if let videoURL = data["videoURL"] as? String {
                completion(videoURL)
            }
        })
    }
}
