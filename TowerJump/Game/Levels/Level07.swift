//
//  Level07.swift
//  TowerJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level07 : Level
{
    override init(worldWidth: CGFloat) {
        super.init(worldWidth: worldWidth)
        self.texturePlatform = SKTexture(imageNamed: "platform01")
        self.wallLeftTexture = SKTexture(imageNamed: "wallLeft01")
        self.wallRightTexture = SKTexture(imageNamed: "wallRight01")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func backgroundColor() -> SKColor {
        return SKColor.init(named: "bgLevel07") ?? super.backgroundColor()
    }
    
    override func platformMinFactor() -> CGFloat {
        return 0.20
    }
    
    override func platformMaxFactor() -> CGFloat {
        return 0.35
    }
    
    override func levelSpeed() -> CGFloat {
        return 105.0
    }
}
