//
//  Level04.swift
//  TowerJump
//
//  Created by Oliver Brehm on 28.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level04: Level {
    override init(worldWidth: CGFloat) {
        super.init(worldWidth: worldWidth)
        self.texturePlatform = SKTexture(imageNamed: "platform02")
        self.wallLeftTexture = SKTexture(imageNamed: "wallLeft01")
        self.wallRightTexture = SKTexture(imageNamed: "wallRight01")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var backgroundColor: SKColor {
        return SKColor.init(named: "bgLevel04") ?? super.backgroundColor
    }
    
    override var platformMinFactor: CGFloat {
        return 0.3
    }
    
    override var platformMaxFactor: CGFloat {
        return 0.55
    }
    
    override var levelSpeed: CGFloat {
        return 80.0
    }
}
