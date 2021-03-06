//
//  GameScene.swift
//  Project20FireworksNight
//
//  Created by Henry on 7/22/15.
//  Copyright (c) 2015 Henry. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // use this to call the launchFireworks() method every six seconds
    var gameTimer: NSTimer!
    // This avoids accidental taps triggered by tapping on the fuse of a firework
    var fireworks =  [SKNode]()
    
    // These three edges are used to define where we launch fireworks from
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    // track the player's score
    var score: Int = 0 {
        didSet {
            
        }
    }
    
    override func didMoveToView(view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        addChild(background)
        
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: "launchFireworks", userInfo: nil, repeats: true)
    }
    
    func createFirework(#xMovement: CGFloat, x: Int, y: Int) {
        
        //Create an SKNode that will act as the firework container, and place it at the X/Y position that was specified
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        //Create a rocket sprite node, give it the name "firework" so we know that it's the important thing, then add it to the container node
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.name = "firework"
        node.addChild(firework)
        
        //Give the firework sprite node one of three random colors: cyan, green or red
        switch RandomInt(min: 0, max: 2) {
        case 0:
            firework.color = UIColor.cyanColor()
            firework.colorBlendFactor = 1
        case 1:
            firework.color = UIColor.greenColor()
            firework.colorBlendFactor = 1
        case 2:
            firework.color = UIColor.redColor()
            firework.colorBlendFactor = 1
        default:
            break
        }
        
        //Create a UIBezierPath that will represent the movement of the firework
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: xMovement, y: 1000))
        
        //Tell the container node to follow that path, turning itself as needed
        let move = SKAction.followPath(path.CGPath, asOffset: true, orientToPath: true, speed: 200)
        node.runAction(move)
        
        //Create particles behind the rocket to make it look like the fireworks are lit
        let particlePath = NSBundle.mainBundle().pathForResource("fuse", ofType: "sks")
        let emitter = NSKeyedUnarchiver.unarchiveObjectWithFile(particlePath!) as! SKEmitterNode
        emitter.position = CGPoint(x: 0, y: -22)
        node.addChild(emitter)
        
        //Add the firework to our fireworks array and also to the scene
        fireworks.append(node)
        addChild(node)
    }
    
    func launchFireworks() {
        
        let movementAmount: CGFloat = 1800
        
        switch RandomInt(min: 0, max: 3) {
        case 0:
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
        case 2:
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        case 3:
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
        default:
            break
        }
    }
    
    func checkForTouches(touches: Set<NSObject>) {
        
        let touch = touches.first as! UITouch
        
        let location = touch.locationInNode(self)
        let nodes = nodesAtPoint(location) as! [SKNode]
        
        for node in nodes {
            if node.isKindOfClass(SKSpriteNode.self) {
                let sprite = node as! SKSpriteNode
                
                if sprite.name == "firework" {
                    //the inner loop ensure that the player can select only one firework color at a time
                    for parent in fireworks {
                        let firework = parent.children[0] as! SKSpriteNode
                        
                        if firework.name == "selected" && firework.color != sprite.color {
                            firework.name == "firework"
                            firework.colorBlendFactor = 1
                        }
                    }
                    sprite.name == "selected"
                    sprite.colorBlendFactor = 0
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        checkForTouches(touches)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        
        checkForTouches(touches)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //loop through the array backwards rather than forwards, because the array items move down when you remove an item
        for var i = fireworks.count - 1; i >= 0; --i {
            let firework = fireworks[i]
            
            if firework.position.y > 900 {
                //this uses a position high above so that rockets can explode off screen
                fireworks.removeAtIndex(i)
                firework.removeFromParent()
            }
        }
    }
}
