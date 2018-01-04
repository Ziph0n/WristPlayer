//
//  NowPlayingInterfaceController.swift
//  WatchTube for Apple Watch Extension
//
//  Created by Florian Hebrard on 28/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import Foundation
import WatchKit

class NowPlayingInterfaceController: WKInterfaceController, WKCrownDelegate {
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var playImage: WKInterfaceImage!
    @IBOutlet var slider: WKInterfaceSlider!
    
    static var playImage: WKInterfaceImage!
    static var video: Video!
    static var isPlaying = false {
        didSet {
            if NowPlayingInterfaceController.playImage != nil {
                if NowPlayingInterfaceController.isPlaying {
                    NowPlayingInterfaceController.playImage.setImage(#imageLiteral(resourceName: "Pause"))
                } else {
                    NowPlayingInterfaceController.playImage.setImage(#imageLiteral(resourceName: "Play"))
                }
            }
        }
    }
    
    var crownAccumulator = 0.0
    var volume: Float? {
        didSet {
            self.slider.setValue(volume! * 100)
            WatchSessionManager.sharedManager.setVolume(volume: volume!)
        }
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        NowPlayingInterfaceController.playImage = self.playImage
        
        crownSequencer.delegate = self

        if context != nil {
            NowPlayingInterfaceController.video = context as! Video
            NowPlayingInterfaceController.isPlaying = true
        }
        
        if NowPlayingInterfaceController.video != nil {
            self.titleLabel.setText(NowPlayingInterfaceController.video.title)
        } else {
            self.titleLabel.setText("Nothing is playing")
        }
        
        if NowPlayingInterfaceController.isPlaying {
            self.playImage.setImage(#imageLiteral(resourceName: "Pause"))
        } else {
            self.playImage.setImage(#imageLiteral(resourceName: "Play"))
        }
    }
    
    override func willActivate() {
        super.willActivate()
        
        WatchSessionManager.sharedManager.getiPhoneVolume() { volume in
            self.volume = volume
        }
        
        crownSequencer.focus()
    }
    
    @IBAction func playButtonTapped() {
        if NowPlayingInterfaceController.video != nil {
            if NowPlayingInterfaceController.isPlaying {
                self.pausePlayer()
            } else {
                self.startPlayer()
            }
        }
    }
    
    func setIsPlaying(isPlaying: Bool) {
        NowPlayingInterfaceController.isPlaying = isPlaying
        if isPlaying {
            self.startPlayer()
        } else {
            self.pausePlayer()
        }
    }
    
    func startPlayer() {
        self.playImage.setImage(#imageLiteral(resourceName: "Pause"))
        WatchSessionManager.sharedManager.playVideo()
        WatchSessionManager.sharedManager.startKeepingAlive()
        NowPlayingInterfaceController.isPlaying = true
    }
    
    func pausePlayer() {
        self.playImage.setImage(#imageLiteral(resourceName: "Play"))
        WatchSessionManager.sharedManager.pauseVideo()
        NowPlayingInterfaceController.isPlaying = false
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        crownAccumulator += rotationalDelta
        
        if crownAccumulator > 0.1 {
            self.volume? += 0.05
            crownAccumulator = 0.0
        } else if crownAccumulator < -0.1 {
            self.volume? -= 0.05
            crownAccumulator = 0.0
        }
    }
    
    @IBAction func sliderValueDidChange(_ value: Float) {
        self.volume? = value / 100
    }
}
