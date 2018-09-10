//
//  BedNode.swift
//  CatNap
//
//  Created by Selina Kröcker on 03.09.18.
//  Copyright © 2018 Selina Piper. All rights reserved.
//

import SpriteKit

class BedNode: SKSpriteNode, EventListenerNode {
    
    func didMoveToScene() {
        print("bed added to scene")
        //creating an stitic physicsbody with an much smaller size than the node itself
        // adding: physicsbody is an optional proberty -> force unwrap
        let bedBodySize = CGSize(width: 40.0, height: 30.0)
        physicsBody = SKPhysicsBody(rectangleOf: bedBodySize)
        physicsBody!.isDynamic = false
        
        physicsBody!.categoryBitMask = PhysicsCategory.Bed
        physicsBody!.collisionBitMask = PhysicsCategory.None
    }
}
