//
//  Level06.swift
//  TowerJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level06 : Level
{
    override init(worldWidth: CGFloat) {
        super.init(worldWidth: worldWidth)
        self.platformTexture = SKTexture(imageNamed: "platform02")
        self.wallLeftTexture = SKTexture(imageNamed: "wallLeft01")
        self.wallRightTexture = SKTexture(imageNamed: "wallRight01")
    }
    
    override func Color() -> SKColor {
        return SKColor.darkGray
    }
    
    override func BackgroundColor() -> SKColor {
        return SKColor.init(named: "bgLevel02") ?? super.BackgroundColor()
    }
    
    override func PlatformMinFactor() -> CGFloat
    {
        return 0.25
    }
    
    override func PlatformMaxFactor() -> CGFloat
    {
        return 0.45
    }
    
    override func GameSpeed() -> CGFloat {
        return 110.0
    }
}
