//
//  ExtraLife.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 06.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class ConsumableExtraLife: Collectable {
    init() {
        let diameter = 30
        super.init(textureName: "extralife", size: CGSize(width: diameter, height: diameter), useBacklight: true)
    }
    
    override var score: Int {
        return ResourceManager.costExtraLife
    }
    
    override func hit() {
        super.hit()
        
        Config.standard.addExtralife()
        
        self.run(SKAction.sequence([
            SKAction.group([
                SoundAction.collectExtralife.action,
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
