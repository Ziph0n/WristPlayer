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
    
    @IBAction func searchVideoButtonTapped() {
        self.presentTextInputController(withSuggestions: ["hi"], allowedInputMode: .plain) { (keywords) in
            if let keyword = keywords as? [String] {
                if keyword.count > 0 {
                    self.getVideos(keyword: keyword[0]) { videos in
                        self.pushController(withName: "VideoListInterfaceController", context: videos)
                    }
                }
            }
        }
    }
    
    func getVideos(keyword: String, completion: @escaping ([Video]) -> Void) {
        Alamofire.request("https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&maxResults=20&order=viewCount&key=AIzaSyDdw5drLrtOTsDmegIz6-VRAhxZ0ol2IKw").responseJSON { response in
            
            var videos = [Video]()
            if let json = response.result.value {
                let response = json as! Dictionary<String, Any>
                let items = response["items"] as! [[String: Any]]
                for (_, item) in items.enumerated() {
                    let videoDetails = item
                    let snippet = videoDetails["snippet"] as! Dictionary<String, Any>
                    let title = snippet["title"] as! String
                    print(title)

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
}
