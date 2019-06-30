//
//  PlaylistRow.swift
//  WatchTube for Apple Watch Extension
//
//  Created by Florian Hebrard on 30/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import Foundation
import WatchKit

class PlaylistRow: NSObject {
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    var playlistId: String!
}
