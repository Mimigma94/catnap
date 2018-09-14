//
//  SpringNode.swift
//  CatNap
//
//  Created by Selina Kröcker on 14.09.18.
//  Copyright © 2018 Selina Piper. All rights reserved.
//

import SpriteKit

class SpringNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    func interact() {
        isUserInteractionEnabled = false
        
        physicsBody!.applyImpulse(CGVector(dx: 0, dy: 250), at: CGPoint(x: size.width/2, y: size.height))
        
        run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
    }
}
