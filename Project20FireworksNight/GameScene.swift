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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
