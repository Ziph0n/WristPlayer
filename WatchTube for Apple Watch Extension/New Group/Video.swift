//
//  Video.swift
//  WatchTube for Apple Watch Extension
//
//  Created by Florian Hebrard on 28/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import Foundation
import Alamofire

class Video {
    
    var id: String
    var title: String
    
    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    class func getVideos(keyword: String, completion: @escaping ([Video]) -> Void) {
        Alamofire.request("https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&maxResults=20&order=viewCount&key=AIzaSyDdw5drLrtOTsDmegIz6-VRAhxZ0ol2IKw").responseJSON { response in
            
            var videos = [Video]()
            if let json = response.result.value {
                let response = json as! Dictionary<String, Any>
                let items = response["items"] as! [[String: Any]]
                for (_, item) in items.enumerated() {
                    let videoDetails = item
                    let snippet = videoDetails["snippet"] as! Dictionary<String, Any>
                    let title = snippet["title"] as! String
                    
                    let id = videoDetails["id"] as! Dictionary<String, Any>
                    
                    guard let videoId = id["videoId"] as? String else {
                        continue
                    }
                    
                    let video = Video(id: videoId, title: title)
                    videos.append(video)
                }
            }
            completion(videos)
        }
    }
    
    class func getPlaylistVideos(playlistId: String, completion: @escaping ([Video]) -> Void) {
        Alamofire.request("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=\(playlistId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&mine=true&access_token=\(User.getAccessToken()?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")").responseJSON { response in
            
            var videos = [Video]()
            if let json = response.result.value {
                let response = json as! Dictionary<String, Any>
                let items = response["items"] as! [[String: Any]]
                for (_, item) in items.enumerated() {
                    let videoDetails = item
                    let snippet = videoDetails["snippet"] as! Dictionary<String, Any>
                    let title = snippet["title"] as! String
                    
                    let resourceId = snippet["resourceId"] as! Dictionary<String, Any>
                    let videoId = resourceId["videoId"] as! String
                    
                    let video = Video(id: videoId, title: title)
                    videos.append(video)
                }
            }
            completion(videos)
        }
    }
}
