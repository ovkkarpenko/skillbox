//
//  GameOverScene.swift
//  lesson_16
//
//  Created by Oleksandr Karpenko on 26.09.2020.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let label = SKLabelNode(text: "Game Over!")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        label.numberOfLines = 0
        
        addChild(label)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let scene = GameScene(size: size)
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(scene, transition: reveal)
    }
    
}
