//
//  Level04.swift
//  TowerJump
//
//  Created by Oliver Brehm on 28.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level04 : Level
{
    override init(worldWidth: CGFloat) {
        super.init(worldWidth: worldWidth)
        self.platformTexture = SKTexture(imageNamed: "platform02")
        self.wallLeftTexture = SKTexture(imageNamed: "wallLeft01")
        self.wallRightTexture = SKTexture(imageNamed: "wallRight01")
    }
    
    override func Color() -> SKColor {
        return SKColor.white
    }
    
    override func BackgroundColor() -> SKColor {
        return SKColor.init(named: "bgLevel02") ?? super.BackgroundColor()
    }
    
    override func PlatformMinFactor() -> CGFloat
    {
        return 0.3
    }
    
    override func PlatformMaxFactor() -> CGFloat
    {
        return 0.6
    }
    
    override func GameSpeed() -> CGFloat {
        return 90.0
    }
}
