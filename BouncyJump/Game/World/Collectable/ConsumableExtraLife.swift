//
//  ExtraLife.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 06.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class ConsumableExtraLife: SKSpriteNode, Collectable {
    static let size: CGFloat = 25.0
    static let score = 2
    
    init() {
        super.init(
            texture: SKTexture(imageNamed: "extralife"),
            color: SKColor.init(white: 0.0, alpha: 0.0),
            size: CGSize(width: ConsumableExtraLife.size, height: ConsumableExtraLife.size))
        
        self.physicsBody = SKPhysicsBody.init(circleOfRadius: ConsumableExtraLife.size / 2.0)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = NodeCategories.consumable
        self.physicsBody?.contactTestBitMask = NodeCategories.player
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.zPosition = NodeZOrder.consumable
    }
    
    func hit() {
        Config.standard.addExtralife()
        
        self.run(SKAction.sequence([
            SKAction.group([
                SoundController.standard.getSoundAction(action: .collectExtralife),
                SKAction.scale(to: 15.0, duration: 0.3),
                SKAction.fadeOut(withDuration: 0.3)
            ]),
            SKAction.run {
                if let game = self.scene as? Game {
                    game.checkShowTutorial(.extraLives)
                }
                
                self.removeAllActions()
                self.removeFromParent()
            }
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
