//
//  WatchSessionManager.swift
//  WatchConnectivityDemo
//
//  Created by Natasha Murashev on 9/3/15.
//  Copyright © 2015 NatashaTheRobot. All rights reserved.
//  Updated by Simon Krüger on 2/27/17.
//  Changes © 2017 Kayoslab.
//

import WatchKit
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    static let sharedManager = WatchSessionManager()
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    fileprivate var validSession: WCSession? {
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        
        // Note: if the device is paired, but your watch app is not installed
        // consider prompting the user to install it for a better experience
        
        #if os(iOS)
            if let session = session, session.isPaired && session.isWatchAppInstalled {
                return session
            }
            return nil
        #elseif os(watchOS)
            return session
        #endif

    }
    
    private override init() {
        super.init()
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    /**
     * Called when the session has completed activation.
     * If session state is WCSessionActivationStateNotActivated there will be an error with more details.
     */
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    #if os(iOS)
        /**
         * Called when the session can no longer be used to modify or add any new transfers and,
         * all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur.
         * This will happen when the selected watch is being changed.
         */
        func sessionDidBecomeInactive(_ session: WCSession) {
    
        }
        /**
         * Called when all delegate callbacks for the previously selected watch has occurred.
         * The session can be re-activated for the now selected watch using activateSession.
         */
        func sessionDidDeactivate(_ session: WCSession) {
    
        }
    #endif

}

// MARK: Application Context
// use when your app needs only the latest information
// if the data was not sent, it will be replaced
extension WatchSessionManager {
    
    // Sender
    func updateApplicationContext(applicationContext: [String : AnyObject]) throws {
        if let session = validSession {
            do {
                try session.updateApplicationContext(applicationContext)
            } catch let error {
                throw error
            }
        }
    }
    
    // Receiver
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        // handle receiving application context
        DispatchQueue.main.async() {
            // make sure to put on the main queue to update UI!
        }
    }
}

// MARK: User Info
// use when your app needs all the data
// FIFO queue
extension WatchSessionManager {
    
    // Sender
    func transferUserInfo(userInfo: [String : AnyObject]) -> WCSessionUserInfoTransfer? {
        return validSession?.transferUserInfo(userInfo)
    }
    
    func session(session: WCSession, didFinishUserInfoTransfer userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        // implement this on the sender if you need to confirm that
        // the user info did in fact transfer
    }
    
    // Receiver
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        // handle receiving user info
        DispatchQueue.main.async() {
            // make sure to put on the main queue to update UI!
        }
    }
    
}

// MARK: Transfer File
extension WatchSessionManager {
    
    // Sender
    func transferFile(file: NSURL, metadata: [String : AnyObject]) -> WCSessionFileTransfer? {
        return validSession?.transferFile(file as URL, metadata: metadata)
    }
    
    func session(session: WCSession, didFinishFileTransfer fileTransfer: WCSessionFileTransfer, error: Error?) {
        // handle filed transfer completion
    }
    
    // Receiver
    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
        // handle receiving file
        DispatchQueue.main.async() {
            // make sure to put on the main queue to update UI!
        }
    }
}


// MARK: Interactive Messaging
extension WatchSessionManager {
    
    // Live messaging! App has to be reachable
    private var validReachableSession: WCSession? {
        if let session = validSession, session.isReachable {
            return session
        }
        return nil
    }
    
    // Sender
    func sendMessage(message: [String : AnyObject], replyHandler: (([String : Any]) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    
    func sendMessageData(data: Data, replyHandler: ((Data) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        validReachableSession?.sendMessageData(data, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    
    // Receiver
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        // handle receiving message
        DispatchQueue.main.async() {
            // make sure to put on the main queue to update UI!
        }
    }
    
    func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
        // handle receiving message data
        DispatchQueue.main.async() {
            // make sure to put on the main queue to update UI!
        }
    }
}
