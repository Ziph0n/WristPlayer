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
import AVKit
import MediaPlayer

class ViewController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet var statusLabel: UILabel!
    
    static var staticPlayerView: YTPlayerView!
    static var staticStatusLabel: UILabel!
    
    static var shouldPlayAgain = false
    var shouldSendStartMessageToWatch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.playerView.delegate = self

        ViewController.staticPlayerView = self.playerView
        ViewController.staticStatusLabel = self.statusLabel
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
    
    class func playVideo() {
        ViewController.staticPlayerView.isHidden = false
        ViewController.staticStatusLabel.isHidden = true
        ViewController.staticPlayerView.playVideo()
    }
    
    class func pauseVideo() {
        ViewController.staticPlayerView.pauseVideo()
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case YTPlayerState.playing:
            if shouldSendStartMessageToWatch {
                iPhoneSessionManager.sharedManager.sendStartMessageToWatch()
                self.playerView.isHidden = false
                self.statusLabel.isHidden = true
            }
        case YTPlayerState.paused:
            if ViewController.shouldPlayAgain {
                shouldSendStartMessageToWatch = false
                self.playerView.playVideo()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.shouldSendStartMessageToWatch = true
                }
            } else {
                iPhoneSessionManager.sharedManager.sendStopMessageToWatch()
            }
        case YTPlayerState.ended:
            iPhoneSessionManager.sharedManager.sendStopMessageToWatch()
            self.playerView.isHidden = true
            self.statusLabel.isHidden = false
        default:
            break
        }
    }
    
}
