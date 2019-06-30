//
//  StartStopInterfaceController.swift
//  WatchVideo
//
//  Created by Florian Hebrard on 21/01/2018.
//  Copyright © 2018 Florian Hebrard. All rights reserved.
//

import Foundation
import WatchKit

class StartStopInterfaceController: WKInterfaceController {
    
    @IBOutlet var statusLabel: WKInterfaceLabel!
    
    var video: Video!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if HealthSessionManager.sharedManager.isWorkoutRunning {
            self.statusLabel.setText("Status: Running")
        } else {
            self.statusLabel.setText("Status: Not running")
        }
        
        if context != nil {
            self.video = context as! Video
        }
    }
    
    @IBAction func startButtonTapped() {
        HealthSessionManager.sharedManager.startSession()
        self.pushController(withName: "NowPlayingInterfaceController", context: self.video)
        
        self.statusLabel.setText("Status: Running")
    }
    
    @IBAction func stopButtonTapped() {
        HealthSessionManager.sharedManager.endSession()
        
        self.statusLabel.setText("Status: Not running")
    }
}
