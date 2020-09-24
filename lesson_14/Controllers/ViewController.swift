//
//  ViewController.swift
//  lesson_14
//
//  Created by Oleksandr Karpenko on 23.09.2020.
//

import UIKit
import SceneKit
import ARKit

struct CollisionCategory: OptionSet {
    
    let rawValue: Int
    
    static let missileCategory = CollisionCategory(rawValue: 1 << 0)
    static let targerCategory = CollisionCategory(rawValue: 1 << 1)
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var currentColor: UILabel!
    
    var score = 0
    var timer = 30
    var selectedColor = UIColor.blue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        
        addTargetNodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.timer -= 1
            self.timerLabel.text = "\(self.timer)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    @IBAction func selectBlueColor(_ sender: Any) {
        selectedColor = .blue
        currentColor.text = "Current color: Blue"
    }
    
    @IBAction func selectYellowColor(_ sender: Any) {
        selectedColor = .yellow
        currentColor.text = "Current color: Yellow"
    }
    
    @IBAction func selectOrangeColor(_ sender: Any) {
        selectedColor = .orange
        currentColor.text = "Current color: Orange"
    }
    
    @IBAction func selectRedColor(_ sender: Any) {
        selectedColor = .red
        currentColor.text = "Current color: Red"
    }
    
    @IBAction func selectGreenColor(_ sender: Any) {
        selectedColor = .green
        currentColor.text = "Current color: Green"
    }
    
    @IBAction func selectPinkColor(_ sender: Any) {
        selectedColor = .systemPink
        currentColor.text = "Current color: Pink"
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        fireMissile()
    }
    
    func getUserVector() -> (SCNVector3, SCNVector3) {
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform)
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43)
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    func addTargetNodes() {
        for _ in 1...100 {
            let node = createBox()
            
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            node.physicsBody?.isAffectedByGravity = false
            
            node.position = SCNVector3(randomFLoat(min: -10, max: 10), randomFLoat(min: -4, max: 5), randomFLoat(min: -10, max: 10))
            
            let action: SCNAction = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 1.0)
            let forever = SCNAction.repeatForever(action)
            node.runAction(forever)
            
            node.physicsBody?.categoryBitMask = CollisionCategory.targerCategory.rawValue
            node.physicsBody?.contactTestBitMask = CollisionCategory.missileCategory.rawValue
            
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    func fireMissile() {
        let node = createMissile()
        
        let (direction, position) = self.getUserVector()
        node.position = position
        
        let nodeDirection = SCNVector3(direction.x * 4, direction.y * 4, direction.z * 4)
        node.physicsBody?.applyForce(nodeDirection, asImpulse: true)
        
        sceneView.scene.rootNode.addChildNode(node)
        
        Timer.scheduledTimer(withTimeInterval: 7.0, repeats: false) { timer in
            node.removeFromParentNode()
        }
    }
    
    func createMissile() -> SCNNode {
        let node = createSphere()
        
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.isAffectedByGravity = false
        
        node.physicsBody?.categoryBitMask = CollisionCategory.missileCategory.rawValue
        node.physicsBody?.contactTestBitMask = CollisionCategory.targerCategory.rawValue
        
        return node
    }
    
    func createBox() -> SCNNode {
        let boxGeometry = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = randomColor()
        material.specular.contents = UIColor(white: 0.6, alpha: 1.0)
        
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.geometry?.materials = [material]
        
        return boxNode
    }
    
    func createSphere() -> SCNNode {
        let sphereGeometry = SCNSphere(radius: 0.2)
        
        let material = SCNMaterial()
        material.diffuse.contents = selectedColor
        material.specular.contents = UIColor(white: 0.6, alpha: 1.0)
        
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.geometry?.materials = [material]
        
        return sphereNode
    }
    
    func randomFLoat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF * (max - min) + min)
    }
    
    let colors = [UIColor.blue, UIColor.yellow, UIColor.orange, UIColor.red, UIColor.green, UIColor.systemPink]
    func randomColor() -> UIColor {
        return colors[Int.random(in: 0..<colors.count)]
    }
    
}

extension ViewController: ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.targerCategory.rawValue ||
            contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.targerCategory.rawValue {
            let colorNodeA = contact.nodeA.geometry!.materials[0].diffuse.contents as! UIColor
            let colorNodeB = contact.nodeB.geometry!.materials[0].diffuse.contents as! UIColor
            
            if colorNodeA == colorNodeB {
                DispatchQueue.main.async {
                    contact.nodeA.removeFromParentNode()
                    contact.nodeB.removeFromParentNode()
                    
                    self.score += 10
                    self.scoreLabel.text = "\(self.score)"
                }
            } else {
                DispatchQueue.main.async {
                    contact.nodeB.removeFromParentNode()
                }
            }
        }
    }
    
}
