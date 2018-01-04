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
    var timer: Timer! = nil
    
    func startSession() {
        
        if (WCSession.isSupported()) {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let action = message["action"] as? String {
            if action == "stop" {
                DispatchQueue.main.async {
                    self.stopKeepingAlive()
                    NowPlayingInterfaceController.isPlaying = false
                }
            }
            if action == "start" {
                DispatchQueue.main.async {
                    self.startKeepingAlive()
                    NowPlayingInterfaceController.isPlaying = true
                }
            }
            if action == "token" {
                let accessToken = message["accessToken"] as! String
                UserDefaults.standard.set(accessToken, forKey: preferencesKeys.accessToken)
                User.userLoggedIn = "true"
                User.accessTokenRefreshed = true
            }
            if action == "userNotLoggedIn" {
                User.userLoggedIn = "false"
            }
        }
        
        var replyValues = Dictionary<String, AnyObject>()
        replyValues["status"] = "watch" as AnyObject
        replyHandler(replyValues)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func startVideo(id: String) {
        let applicationData = ["action": "startVideo",
                               "id": id]
        session?.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
        
        self.startKeepingAlive()
    }
    
    func playVideo() {
        let applicationData = ["action": "play"]
        session?.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }
    
    func pauseVideo() {
        let applicationData = ["action": "pause"]
        session?.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }
    
    func startKeepingAlive() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.keepAlive), userInfo: nil, repeats: true)
        }
    }
    
    func stopKeepingAlive() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    @objc func keepAlive() {
        let applicationData = ["action": "keepalive"]
        session?.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }
    
    func getiPhoneVolume(completion: @escaping (Float) -> ()) {
        let applicationData = ["action": "getVolume"]
        session?.sendMessage(applicationData, replyHandler: { (data) in
            if let volume = data["volume"] as? Float {
                completion(volume)
            }
        }) { (error) in
            print(error)
        }
    }
    
    func setVolume(volume: Float) {
        let applicationData = ["action": "setVolume",
                               "volume": volume] as [String : Any]
        session?.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }
    
    func wakeUpiPhone() {
        let applicationData = ["action": "yoWakeUp"]
        session?.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }
}
