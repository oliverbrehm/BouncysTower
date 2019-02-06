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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func BackgroundColor() -> SKColor {
        return SKColor.init(named: "bgLevel06") ?? super.BackgroundColor()
    }
    
    override func PlatformMinFactor() -> CGFloat
    {
        return 0.25
    }
    
    override func PlatformMaxFactor() -> CGFloat
    {
        return 0.40
    }
    
    override func LevelSpeed() -> CGFloat {
        return 100.0
    }
}
