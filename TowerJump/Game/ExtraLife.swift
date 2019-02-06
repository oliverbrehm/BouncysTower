//
//  ExtraLife.swift
//  TowerJump
//
//  Created by Oliver Brehm on 06.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class ExtraLife: SKSpriteNode
{
    public static let SIZE: CGFloat = 25.0
    public static let SCORE = 2
    
    init() {
        super.init(texture: SKTexture(imageNamed: "extralife"), color: SKColor.init(white: 0.0, alpha: 0.0), size: CGSize(width: ExtraLife.SIZE, height: ExtraLife.SIZE))
        
        self.physicsBody = SKPhysicsBody.init(circleOfRadius: ExtraLife.SIZE / 2.0)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = NodeCategories.Coin
        self.physicsBody?.contactTestBitMask = NodeCategories.Player;
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.zPosition = NodeZOrder.Item
    }
    
    public func hit() {
        Config.Default.AddExtralife()
        
        self.run(SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 15.0, duration: 0.3),
                SKAction.fadeOut(withDuration: 0.3)
            ]),
            SKAction.run {
                self.removeAllActions()
                self.removeFromParent()
            }
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
