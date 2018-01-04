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
import GoogleSignIn

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
        
        if let action = message["action"] as? String {
            if action == "startVideo" {
                let id = message["id"] as! String
                DispatchQueue.main.async {
                    ViewController.loadVideo(id: id)
                }
            }
            if action == "play" {
                DispatchQueue.main.async {
                    ViewController.playVideo()
                }
            }
            if action == "pause" {
                DispatchQueue.main.async {
                    ViewController.pauseVideo()
                }
            }
            if action == "getVolume" {
                let volume = AVAudioSession.sharedInstance().outputVolume
                var replyValues = Dictionary<String, Float>()
                replyValues["volume"] = volume
                replyHandler(replyValues)
            }
            if action == "setVolume" {
                let volume = message["volume"] as! Float
                DispatchQueue.main.async {
                    (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) ==  "MPVolumeSlider"}.first as? UISlider)?.setValue(volume, animated: false)
                }
            }
            if action == "yoWakeUp" {
                GIDSignIn.sharedInstance().clientID = "349820541673-eheg9h9maqsl8p7nl3h4q1lisknjb2cb.apps.googleusercontent.com"
                let scope = "https://www.googleapis.com/auth/youtube.readonly"
                let currentScopes = GIDSignIn.sharedInstance().scopes! as NSArray
                GIDSignIn.sharedInstance().scopes = currentScopes.adding(scope)
                
                GIDSignIn.sharedInstance().signInSilently()
                if !GIDSignIn.sharedInstance().hasAuthInKeychain() {
                    iPhoneSessionManager.sharedManager.sendUserNotLoggedIn()
                }
            }
        }
        
        var replyValues = Dictionary<String, AnyObject>()
        replyValues["status"] = "iphone" as AnyObject
        replyHandler(replyValues)
    }
    
    func sendStopMessageToWatch() {
        let applicationData = ["action": "stop"]
        session?.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }
    
    func sendStartMessageToWatch() {
        let applicationData = ["action": "start"]
        session?.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }
    
    func sendAccessToken(accessToken: String) {
        let applicationData = ["action": "token",
                               "accessToken": accessToken]
        session?.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }
    
    func sendUserNotLoggedIn() {
        let applicationData = ["action": "userNotLoggedIn"]
        session?.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
