//
//  ViewController.swift
//  lesson_13
//
//  Created by Oleksandr Karpenko on 22.09.2020.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let store = AssetStore.test()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let (asset, videoComposition) = store.compose()
        startPlaying(asset: asset, videoComposition: videoComposition)
    }
    
    @IBAction func save(_ sender: Any) {
        let (asset, videoComposition) = store.compose()
        
        store.export(asset: asset) { success in
            print(success)
        }
    }
    
    func startPlaying(asset: AVAsset, videoComposition: AVMutableVideoComposition) {
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.videoComposition = videoComposition
        
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds.insetBy(dx: 0, dy: 100)
        
        view.layer.addSublayer(playerLayer)
        player.play()
    }
    
}

