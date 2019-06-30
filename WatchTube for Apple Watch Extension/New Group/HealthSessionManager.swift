//
//  HealthSessionManager.swift
//  WatchVideo
//
//  Created by Florian Hebrard on 21/01/2018.
//  Copyright © 2018 Florian Hebrard. All rights reserved.
//

import Foundation
import HealthKit

class HealthSessionManager: NSObject {
    
    static let sharedManager = HealthSessionManager()

    var healthStore: HKHealthStore?
    var configuration: HKWorkoutConfiguration?
    var session: HKWorkoutSession?

    var isWorkoutRunning = false
    var startDate: Date!
    
    private override init() {
        configuration = HKWorkoutConfiguration()
        configuration?.activityType = .other
        configuration?.locationType = .indoor
    }
    
    func startSession() {
        healthStore = HKHealthStore()
        session = try! HKWorkoutSession(configuration: configuration!)
        startDate = Date()
        healthStore?.start(session!)
        isWorkoutRunning = true
    }
    
    func endSession() {
        if healthStore != nil {
            healthStore?.end(session!)
            startDate = nil
            isWorkoutRunning = false
        }
    }
    
    func getBurnedCalories() -> Int {
        if startDate != nil {
            let prancerciseCaloriesPerHour: Double = 200
            let duration = Date().timeIntervalSince(startDate)
            let hours: Double = duration/3600
            let totalCalories = prancerciseCaloriesPerHour*hours
            return Int(totalCalories)
        } else {
            return 0
        }
    }
}
