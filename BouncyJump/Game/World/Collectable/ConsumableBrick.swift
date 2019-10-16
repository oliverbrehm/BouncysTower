//
//  ConsumableBrick.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 04.03.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class ConsumableBrick: Collectable {
    let brick: Brick
    
    init(brick: Brick) {
        self.brick = brick
        super.init(textureName: brick.textureName, size: CGSize(width: 36.0, height: 24.0), useBacklight: true)
    }
    
    override func hit() {
        super.hit()
        print("hit brick")
        
        TowerBricks.standard.add(brick: brick)
        
        self.run(SKAction.sequence([
            SKAction.group([
                SoundAction.brick(type: brick).action,
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
    
    override var score: Int {
        return brick.cost
    }
    
    required init?(coder aDecoder: NSCoder) {
        brick = .standard
        super.init(coder: aDecoder)
    }
}
