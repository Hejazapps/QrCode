//
//  VideoSplashViewController.swift
//  QrCodeMaker
//
//  Created by Md. Ikramul Murad on 12/8/23.
//

import UIKit
import AVFoundation

class VideoSplashViewController: UIViewController {
    var player: AVPlayer!
    
    deinit {
        print("deinit of VideoSplashViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("video splash view controller")
        loadVideo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("VideoSplashViewController -> viewDidDisappear()")
        
        removeAllObservers()
    }
    
    func removeAllObservers() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func loadVideo() {
        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }

        guard let path = Bundle.main.path(forResource: "Video", ofType: "mp4") else {
            print("Video path is wrong")
            return
        }
        
        let videoURL = NSURL(fileURLWithPath: path)
        player = AVPlayer(url: videoURL as URL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        self.view.layer.addSublayer(playerLayer)

        player.seek(to: CMTime.zero)
        player.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinish(note:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func playerDidFinish(note: NSNotification) {
        print("Video Finished")
        self.performSegue(withIdentifier: "mainSegue", sender: nil)
    }
    
    @objc func appWillEnterForeground() {
        print("appWillEnterForeground()")
        
        player.play()
    }
}
