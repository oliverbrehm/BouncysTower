//
//  Level08.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level08 : Level
{
    override init(worldWidth: CGFloat) {
        super.init(worldWidth: worldWidth)
        self.platformTexture = SKTexture(imageNamed: "platform02")
        self.wallLeftTexture = SKTexture(imageNamed: "wallLeft01")
        self.wallRightTexture = SKTexture(imageNamed: "wallRight01")
    }

    override func BackgroundColor() -> SKColor {
        return SKColor.init(named: "bgLevel02") ?? super.BackgroundColor()
    }
    
    override func PlatformMinFactor() -> CGFloat
    {
        return 0.10
    }
    
    override func PlatformMaxFactor() -> CGFloat
    {
        return 0.30
    }
    
    override func GameSpeed() -> CGFloat {
        return 130.0
    }
}
