//
//  ViewController.swift
//  WatchTube
//
//  Created by Florian Hebrard on 28/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import AVFoundation

class ViewController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet var playerView: YTPlayerView!

    static var staticPlayerView: YTPlayerView!
    static var shouldPlayAgain = false
    var shouldSendStartMessageToWatch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.playerView.delegate = self
        
        ViewController.staticPlayerView = self.playerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func loadVideo(id: String) {
        DispatchQueue.main.async {
            let session = AVAudioSession.sharedInstance()
            
            try! session.setCategory(AVAudioSessionCategoryPlayback)
            try! session.setActive(true)
            
            let playerVars = [
                "origin" : "https://www.example.com"
            ] as [String : Any]
            ViewController.staticPlayerView.load(withVideoId: id, playerVars: playerVars)
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case YTPlayerState.playing:
            if shouldSendStartMessageToWatch {
                AppDelegate.sendStartMessageToWatch()
            }
        case YTPlayerState.paused:
            if ViewController.shouldPlayAgain {
                shouldSendStartMessageToWatch = false
                self.playerView.playVideo()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.shouldSendStartMessageToWatch = true
                }
            } else {
                AppDelegate.sendStopMessageToWatch()
            }
        case YTPlayerState.ended:
            AppDelegate.sendStopMessageToWatch()
        default:
            break
        }
    }
    
    
}
