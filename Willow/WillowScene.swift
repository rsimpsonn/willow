//
//  WillowScene.swift
//  Willow
//
//  Created by Ryan Simpson on 12/19/17.
//  Copyright © 2017 Ryan Simpson. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class WillowScene: SKScene {
    
    var blinkFrames:[SKTexture]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize){
        super.init(size: size)
        var frames:[SKTexture] = []
        let blinkAtlas = SKTextureAtlas(named: "blink")
        
        for index in 1 ... 9 {
            let textureName = "blink_\(index)"
            let texture = blinkAtlas.textureNamed(textureName)
            frames.append(texture)
        }
        
        self.blinkFrames = frames
    }
    
    func floatWillow() {
        let texture = self.blinkFrames![0]
        let willow = SKSpriteNode(texture: texture)
        
        willow.size = CGSize(width: 140, height: 140)
        willow.position = CGPoint(x: 50, y: 50)
        
        self.addChild(willow)
        
        willow.run(SKAction.repeatForever(SKAction.animate(withNormalTextures: self.blinkFrames!, timePerFrame: 0.01, resize: false, restore: true)))
        
        let floatAction = SKAction.moveBy(x: 0, y: -15, duration: 0.1)
        
        willow.run(floatAction)
    }
}
