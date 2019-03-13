//
//  ConsumableBrick.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 04.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class ConsumableBrick: SKSpriteNode, Collectable {
    static let size = CGSize(width: 36.0, height: 24.0)
    static let score = 2
    
    let brick: Brick
    
    init(brick: Brick) {
        self.brick = brick
        
        super.init(
            texture: SKTexture(imageNamed: brick.textureName),
            color: SKColor.init(white: 0.0, alpha: 0.0),
            size: ConsumableBrick.size)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: ConsumableBrick.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = NodeCategories.consumable
        self.physicsBody?.contactTestBitMask = NodeCategories.player
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.zPosition = NodeZOrder.consumable
    }
    
    func hit() {
        TowerBricks.standard.add(brick: brick)
        
        // TODO make Collectable superclass not protocal and move to super
        self.run(SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 15.0, duration: 0.3),
                SKAction.fadeOut(withDuration: 0.3)
                ]),
            SKAction.run {
                if let game = self.scene as? Game {
                    game.checkShowTutorial(.bricks)
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
