//
//  GameViewController.swift
//  lesson_16
//
//  Created by Oleksandr Karpenko on 25.09.2020.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.frame.size)
        let skView = view as! SKView
        skView.presentScene(scene)
    }
    
}
