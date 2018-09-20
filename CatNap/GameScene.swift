//
//  GameScene.swift
//  CatNap
//
//  Created by Selina Kröcker on 31.08.18.
//  Copyright © 2018 Selina Piper. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None: UInt32 = 0         // 000 0000
    static let cat: UInt32 = 0b1        // 000 0001
    static let Block: UInt32 = 0b10     // 000 0010
    static let Bed: UInt32 = 0b100      // 000 0100
    static let Edge: UInt32 = 0b1000    // 000 1000
    static let Label: UInt32 = 0b10000  // 001 0000
    static let Spring: UInt32 = 0b100000// 010 0000
    static let Hook: UInt32 = 0b1000000 // 100 0000
}

protocol EventListenerNode {
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //--------------------------------------------------
    // MARK: - Properties
    //--------------------------------------------------
    
    var bedNode: BedNode!
    var catNode: CatNode!
    var playable = true
    var currentLevel: Int = 0
    var hookBaseNode: HookBaseNode?
    
    //--------------------------------------------------
    // MARK: - Lifecycle
    //--------------------------------------------------
    
    override func didMove(to view: SKView) {
        
        // Animation of tail wouldn`t work otherwise
        // For more information see: https://stackoverflow.com/a/50064653
        self.isPaused = true
        self.isPaused = false
        
        //calculate playable margin
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2
        
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height-playableMargin*2)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        
        enumerateChildNodes(withName: "//*", using: {node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
        
        bedNode = childNode(withName: "bed") as! BedNode
        catNode = childNode(withName: "//cat_body") as! CatNode
        
        SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
        
        // -π/4 sind -45Grad π ist in den SKUtils definiert
        //let rotationConstrain = SKConstraint.zRotation(SKRange(lowerLimit: -π/4, upperLimit: π/4))
        // catNode.parent!.constraints = [rotationConstrain]
        
        hookBaseNode = childNode(withName: "hookBase") as? HookBaseNode
    }
    
    override func didSimulatePhysics() {
        if playable && hookBaseNode?.isHooked != true {
            if abs(catNode.parent!.zRotation) > CGFloat(25).degreesToRadians() {
                lose()
            }
        }
    
    }
    
    //--------------------------------------------------
    // MARK: - Methods
    //--------------------------------------------------
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if collision == PhysicsCategory.Label | PhysicsCategory.Edge {
            let labelNode = contact.bodyA.categoryBitMask == PhysicsCategory.Label ?
                contact.bodyA.node :
                contact.bodyB.node
            
            if let message = labelNode as? MessageNode {
                message.didBounce()
            }
        }

        if !playable {
            return
        }
        
        //Wenn die Katze in das Bett fällt = gewonnen, und wenn sie dien Boden berührt = verloren
        if collision == PhysicsCategory.cat | PhysicsCategory.Bed {
            print("SUCCESS")
            win()
        } else if collision == PhysicsCategory.cat | PhysicsCategory.Edge {
            print("FAIL")
            lose()
        }
        
        if collision == PhysicsCategory.cat | PhysicsCategory.Hook && hookBaseNode?.isHooked == false {
            hookBaseNode!.hookCat(catPhysicsBody: catNode.parent!.physicsBody!)
            
            
        }
    }
    
    func inGameMessage(text:String) {
        let message = MessageNode(message: text)
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message)
    }
    
    func newGame() {
        view!.presentScene(GameScene.level(levelNum: currentLevel))
    }
    
    func lose() {
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("lose.mp3")
        
        inGameMessage(text: "Try again...")
        
        run(SKAction.afterDelay(5, runBlock: newGame))
        catNode.wakeUp()
    }
    
    func win() {
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("win.mp3")
        
        inGameMessage(text: "Nice job!")
        
        run(SKAction.afterDelay(3, runBlock: newGame))
        catNode.curlAt(scenePoint: bedNode.position)
    }
    
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
        scene.scaleMode = .aspectFill
        return scene
    }
}

