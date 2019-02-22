//
//  Coin.swift
//  TowerJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode {
    static let size: CGFloat = 12.0
    static let score = 2
    
    init() {
        super.init(texture: SKTexture(imageNamed: "coin"), color: SKColor.init(white: 0.0, alpha: 0.0),
            size: CGSize(width: Coin.size, height: Coin.size))
        
        self.physicsBody = SKPhysicsBody.init(circleOfRadius: Coin.size / 2.0)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = NodeCategories.coin
        self.physicsBody?.contactTestBitMask = NodeCategories.player
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.zPosition = NodeZOrder.item        
    }
    
    func hit() {
        Config.standard.addCoin()

        self.run(SKAction.sequence([
            SKAction.group([
                SoundController.standard.getSoundAction(action: .coin),
                SKAction.sequence([
                    SKAction.moveBy(x: 0.0, y: 4.0, duration: 0.1),
                    SKAction.scale(by: 0.2, duration: 0.1),
                    SKAction.fadeOut(withDuration: 0.2)
                ])
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
