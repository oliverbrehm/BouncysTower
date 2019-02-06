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
        self.platformTexture = SKTexture(imageNamed: "platform01")
        self.wallLeftTexture = SKTexture(imageNamed: "wallLeft01")
        self.wallRightTexture = SKTexture(imageNamed: "wallRight01")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func BackgroundColor() -> SKColor {
        return SKColor.init(named: "bgLevel07") ?? super.BackgroundColor()
    }
    
    override func PlatformMinFactor() -> CGFloat
    {
        return 0.20
    }
    
    override func PlatformMaxFactor() -> CGFloat
    {
        return 0.35
    }
    
    override func LevelSpeed() -> CGFloat {
        return 105.0
    }
}
