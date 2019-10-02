//
//  Collectable.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 04.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Collectable: SKSpriteNode {
    
    var hitAction: (() -> Void)?
    
    init(textureName: String, size: CGSize, useBacklight: Bool = false) {
        super.init(
            texture: SKTexture(imageNamed: textureName),
            color: SKColor.init(white: 0.0, alpha: 0.0),
            size: size)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = NodeCategories.consumable
        self.physicsBody?.contactTestBitMask = NodeCategories.player
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.zPosition = NodeZOrder.consumable
        
        if(useBacklight) {
            let light = SKSpriteNode(imageNamed: "pointlight")
            self.addChild(light)
            light.size = self.size * 6.0
            light.colorBlendFactor = 1.0
            light.color = Colors.collectableBacklight
            light.zPosition = -1.0 // behind collectable
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func hit() {
        self.physicsBody?.contactTestBitMask = 0x0
        hitAction?()
    }
    
    var score: Int {
        return 0
    }
    
}
