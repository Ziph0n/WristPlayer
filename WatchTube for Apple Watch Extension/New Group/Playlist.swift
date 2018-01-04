//
//  Playlist.swift
//  WatchTube for Apple Watch Extension
//
//  Created by Florian Hebrard on 30/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import Foundation
import Alamofire

class Playlist {
    
    var id: String
    var title: String
    
    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    class func getUserPlaylists(completion: @escaping ([Playlist]) -> Void) {
        Alamofire.request("https://www.googleapis.com/youtube/v3/playlists?part=snippet&mine=true&access_token=\(User.getAccessToken()?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")").responseJSON { response in
            
            print(User.getAccessToken())
            
            var playlists = [Playlist]()
            if let json = response.result.value {
                let response = json as! Dictionary<String, Any>
                let items = response["items"] as! [[String: Any]]
                for (_, item) in items.enumerated() {
                    let playlistDetails = item
                    
                    let playlistId = playlistDetails["id"] as! String
                    
                    let snippet = playlistDetails["snippet"] as! Dictionary<String, Any>
                    let title = snippet["title"] as! String
                    
                    let playlist = Playlist(id: playlistId, title: title)
                    playlists.append(playlist)
                }
            }
            completion(playlists)
        }
    }

}
