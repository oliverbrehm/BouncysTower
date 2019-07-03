//
//  ExtraLife.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 06.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class ConsumableExtraLife: Collectable {
    init() {
        super.init(textureName: "extralife", size: CGSize(width: 25.0, height: 25.0), useBacklight: true)
    }
    
    override var score: Int {
        return ResourceManager.costExtraLife
    }
    
    override func hit() {
        super.hit()
        
        Config.standard.addExtralife()
        
        self.run(SKAction.sequence([
            SKAction.group([
                AudioManager.standard.getSoundAction(action: .collectExtralife),
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
