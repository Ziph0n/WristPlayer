//
//  User.swift
//  WatchTube for Apple Watch Extension
//
//  Created by Florian Hebrard on 30/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import Foundation

class User {
    
    static var accessTokenRefreshed = false
    static var userLoggedIn = "unknown"
    
    class func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: preferencesKeys.accessToken)
    }
}
