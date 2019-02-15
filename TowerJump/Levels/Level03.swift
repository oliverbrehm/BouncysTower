//
//  Level03.swift
//  TowerJump
//
//  Created by Oliver Brehm on 28.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level03 : Level
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
        return SKColor.init(named: "bgLevel03") ?? super.backgroundColor()
    }
    
    override func platformMinFactor() -> CGFloat
    {
        return 0.3
    }
    
    override func platformMaxFactor() -> CGFloat
    {
        return 0.65
    }
    
    override func levelSpeed() -> CGFloat {
        return 70.0
    }
}
