//
//  HookBaseNode.swift
//  CatNap
//
//  Created by Selina Kröcker on 19.09.18.
//  Copyright © 2018 Selina Piper. All rights reserved.
//

import SpriteKit

class HookBaseNode: SKSpriteNode, EventListenerNode {
    
    //--------------------------------------------------
    // MARK: - Properties
    //--------------------------------------------------
    
    private var hookNode = SKSpriteNode(imageNamed: "hook")
    private var ropeNode = SKSpriteNode(imageNamed: "rope")
    private var hookJoint: SKPhysicsJointFixed!
    
    var isHooked: Bool {
        return hookJoint != nil
    }
    
    //--------------------------------------------------
    // MARK: - Methods
    //--------------------------------------------------
    
    func didMoveToScene() {
        guard let scene = scene else {
            return }
        
        let ceilingFix = SKPhysicsJointFixed.joint(withBodyA: scene.physicsBody!, bodyB: physicsBody!, anchor: CGPoint.zero)
        scene.physicsWorld.add(ceilingFix)
        
        ropeNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        ropeNode.zRotation = CGFloat(270).degreesToRadians()
        ropeNode.position = position
        scene.addChild(ropeNode)
        
        hookNode.position = CGPoint(x: position.x, y: position.y - ropeNode.size.width)
        
        hookNode.physicsBody = SKPhysicsBody(circleOfRadius: hookNode.size.width/2)
        hookNode.physicsBody!.categoryBitMask = PhysicsCategory.Hook
        hookNode.physicsBody!.contactTestBitMask = PhysicsCategory.cat
        hookNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        scene.addChild(hookNode)
        
        let hookPosition = CGPoint(x: hookNode.position.x, y: hookNode.position.y+hookNode.size.height/2)
        
        let ropeJoint = SKPhysicsJointSpring.joint(withBodyA: physicsBody!, bodyB: hookNode.physicsBody!, anchorA: position, anchorB: hookPosition)
        
        scene.physicsWorld.add(ropeJoint)
        }
    
}
