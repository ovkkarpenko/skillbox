//
//  GameScene.swift
//  lesson_16
//
//  Created by Oleksandr Karpenko on 25.09.2020.
//

import SpriteKit
import GameplayKit

struct CollisionCategory: OptionSet {
    
    let rawValue: UInt32
    
    static let ballCategory: UInt32 = CollisionCategory(rawValue: 1 << 0).rawValue
    
}

class GameScene: SKScene {
    
    let player = SKShapeNode(circleOfRadius: 20)
    let enemy = SKShapeNode(circleOfRadius: 10)
    
    let scoreLabel = SKLabelNode(text: "Score: 0")
    
    var score = 0
    func updateScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.physicsWorld.contactDelegate = self
        
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 50)
        scoreLabel.fontColor = .white
        
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        player.fillColor = .green
        
        enemy.fillColor = .red
        
        addChild(player)
        addChild(enemy)
        addChild(scoreLabel)
        
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [unowned self] timer in
            score += 1
            enemy.setScale(enemy.xScale + 0.1)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [unowned self] timer in
            updateScore()
        }
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = CollisionCategory.ballCategory
        player.physicsBody?.contactTestBitMask = CollisionCategory.ballCategory
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = CollisionCategory.ballCategory
        enemy.physicsBody?.contactTestBitMask = CollisionCategory.ballCategory
        
        moveEnemy()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        move(node: player, to: touches.first!.location(in: self), speed: 120)
    }
    
    func moveEnemy() {
        move(node: enemy, to: player.position, speed: 80, completion: moveEnemy)
    }
    
    func move(node: SKNode, to: CGPoint, speed: CGFloat, completion: (() -> Void)? = nil) {
        let x = node.position.x
        let y = node.position.y
        let distance = sqrt((x - to.x) * (x - to.x) + (y - to.y) * (y - to.y))
        let duration = TimeInterval(distance / speed)
        let move = SKAction.move(to: to, duration: duration)
        node.run(move, completion: completion ?? {})
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.physicsBody?.categoryBitMask == CollisionCategory.ballCategory ||
            contact.bodyB.node?.physicsBody?.categoryBitMask == CollisionCategory.ballCategory {
            let scene = GameOverScene(size: size)
            scene.label.text = "Game Over!\nYour score: \(score)"
            
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(scene, transition: reveal)
        }
    }
    
}
