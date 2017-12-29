//
//  AppDelegate.swift
//  WatchTube
//
//  Created by Florian Hebrard on 28/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    var session: WCSession!

    static var staticSession: WCSession!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if (WCSession.isSupported()) {
            session = WCSession.default
            session.delegate = self
            session.activate()
            AppDelegate.staticSession = session
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("background")
        ViewController.shouldPlayAgain = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ViewController.shouldPlayAgain = false
        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        var replyValues = Dictionary<String, AnyObject>()
        replyValues["status"] = "appdelegate" as AnyObject
        
        print(message)
        
        if let action = message["action"] as? String {
            if action == "start" {
                let id = message["id"] as! String
                DispatchQueue.main.async {
                    ViewController.loadVideo(id: id)
                }
            }
        }
        
        replyHandler(replyValues)
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        print(messageData)
    }
    
    class func sendStopMessageToWatch() {
        let applicationData = ["action": "stop"]
        AppDelegate.staticSession.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }
    
    class func sendStartMessageToWatch() {
        let applicationData = ["action": "start"]
        AppDelegate.staticSession.sendMessage(applicationData, replyHandler: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }

}

