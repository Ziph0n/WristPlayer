//
//  NowPlayingInterfaceController.swift
//  WatchTube for Apple Watch Extension
//
//  Created by Florian Hebrard on 28/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import Foundation
import WatchKit
import Alamofire

class NowPlayingInterfaceController: WKInterfaceController {
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var movie: WKInterfaceMovie!
    
    var video: Video!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if context != nil {
            self.video = context as! Video
        }
        
        if self.video != nil {
            self.titleLabel.setText(self.video.title)
        } else {
            self.titleLabel.setText("Nothing is playing")
        }
        
        self.statusLabel.setText("Searching video...")
        
        
        /*XCDYouTubeClient.default().getVideoWithIdentifier(NowPlayingInterfaceController.video.id, completionHandler: { (video, error) in
            if error == nil {
                let videoURL = video?.streamURLs[XCDYouTubeVideoQuality.small240.rawValue]
                print(videoURL)
                self.statusLabel.setText("Loading video...")
                
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video.mp4")
                    
                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }
                
                Alamofire.download(videoURL!, to: destination).response { response in
                    print(response)
                    if response.destinationURL != nil {
                        self.movie.setMovieURL(response.destinationURL!)
                        self.statusLabel.setText("Tap to play!")
                    }
                }
            } else {
                print(error)
            }
        })*/
        
        
        WatchSessionManager.sharedManager.getVideoURL(id: self.video.id) { videoURL in

            self.statusLabel.setText("Loading video... 0%")

            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video.mp4")

                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            Alamofire
                .download(videoURL, to: destination).response { response in
                    if response.destinationURL != nil {
                        self.movie.setMovieURL(response.destinationURL!)
                        self.statusLabel.setText("Tap to play!")
                    }
                }
                .downloadProgress(closure: { (progress) in
                    let percent = Int((round(100 * progress.fractionCompleted) / 100) * 100)
                    self.statusLabel.setText("Loading video... \(percent)%")
                })
        }
        
    }
    
    override func willActivate() {
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
    }
    
}
