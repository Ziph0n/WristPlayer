//
//  MainInterfaceController.swift
//  WatchTube for Apple Watch Extension
//
//  Created by Florian Hebrard on 28/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import Foundation
import WatchKit
import Alamofire

class MainInterfaceController: WKInterfaceController {
    
    @IBOutlet var workoutButton: WKInterfaceButton!
    @IBOutlet var burnedCaloriesLabel: WKInterfaceLabel!
    
    var caloriesTimer: Timer!

    override func didAppear() {
        if !HealthSessionManager.sharedManager.isWorkoutRunning {
            self.workoutButton.setTitle("Start Workout")
            self.workoutButton.setBackgroundColor(UIColor(red: 5/255, green: 224/255, blue: 32/255, alpha: 0.38))
        } else {
            self.workoutButton.setTitle("Stop Workout")
            self.workoutButton.setBackgroundColor(UIColor(red: 224/255, green: 0/255, blue: 20/255, alpha: 0.38))
            self.startTimer()
        }
    }
    
    override func didDeactivate() {
        self.stopTimer()
    }
    
    @IBAction func workoutButtonTapped() {
        if HealthSessionManager.sharedManager.isWorkoutRunning {
            HealthSessionManager.sharedManager.endSession()
            self.workoutButton.setTitle("Start Workout")
            self.workoutButton.setBackgroundColor(UIColor(red: 5/255, green: 224/255, blue: 32/255, alpha: 0.38))
            self.stopTimer()
        } else {
            HealthSessionManager.sharedManager.startSession()
            self.workoutButton.setTitle("Stop Workout")
            self.workoutButton.setBackgroundColor(UIColor(red: 224/255, green: 0/255, blue: 20/255, alpha: 0.38))
            self.startTimer()
        }
    }
    
    func startTimer() {
        if caloriesTimer == nil {
            burnedCaloriesLabel.setText("Burned calories: \(HealthSessionManager.sharedManager.getBurnedCalories())")
            caloriesTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.updateCalories), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if caloriesTimer != nil {
            caloriesTimer.invalidate()
            caloriesTimer = nil
        }
    }
    
    @objc func updateCalories() {
        burnedCaloriesLabel.setText("Burned calories: \(HealthSessionManager.sharedManager.getBurnedCalories())")
    }
    
    @IBAction func searchVideoButtonTapped() {
        
        let keywordsHistory = UserDefaults.standard.stringArray(forKey: preferencesKeys.keywordsHistory) ?? [String]()
        var lastTwentyKeywordsHistory = Array(keywordsHistory.suffix(20))
        if lastTwentyKeywordsHistory.count == 0 {
            lastTwentyKeywordsHistory.append("Tove Lo")
        }
        
        self.presentTextInputController(withSuggestions: lastTwentyKeywordsHistory.reversed(), allowedInputMode: .plain) { (keywords) in
            if let keyword = keywords as? [String] {
                if keyword.count > 0 {
                    lastTwentyKeywordsHistory.append(keyword[0])
                    UserDefaults.standard.set(lastTwentyKeywordsHistory, forKey: preferencesKeys.keywordsHistory)
                    let context = ["action": "search",
                                   "query": keyword[0]]
                    self.pushController(withName: "VideoListInterfaceController", context: context)
                }
            }
        }
    }
    
    @IBAction func myPlaylistsButtonTapped() {
        self.pushController(withName: "PlaylistListInterfaceController", context: nil)
    }
    
}
