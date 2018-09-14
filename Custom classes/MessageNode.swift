//
//  MessageNode.swift
//  CatNap
//
//  Created by Selina Kröcker on 05.09.18.
//  Copyright © 2018 Selina Piper. All rights reserved.
//

import SpriteKit

class MessageNode: SKLabelNode {
    
     private var numberOfBounces = 0
    
    convenience init(message: String) {
        self.init(fontNamed: "AvenirNext-Regular")
        
        text = message
        fontSize = 256.0
        fontColor = SKColor.gray
        zPosition = 1000
        
        let front = SKLabelNode(fontNamed: "AvenirNext-Regular")
        front.text = message
        front.fontSize = 256.0
        front.fontColor = SKColor.white
        front.position = CGPoint(x: -2, y: -2)
        addChild(front)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody!.collisionBitMask = PhysicsCategory.Edge
        physicsBody!.categoryBitMask = PhysicsCategory.Label
        physicsBody!.contactTestBitMask = PhysicsCategory.Edge
        physicsBody!.restitution = 0.7
    }
    
    func didBounce() {
        numberOfBounces += 1
        if numberOfBounces < 4 {
            return
        } else {
            removeFromParent()
        }
    }
}
