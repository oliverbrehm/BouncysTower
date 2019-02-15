//
//  Level01.swift
//  TowerJump
//
//  Created by Oliver Brehm on 25.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Level01 : Level
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
        return SKColor.init(named: "bgLevel01") ?? super.backgroundColor()
    }

    override func platformMinFactor() -> CGFloat
    {
        return 0.4
    }
    
    override func platformMaxFactor() -> CGFloat
    {
        return 0.8
    }
    
    override func levelSpeed() -> CGFloat {
        return 40.0
    }
    
    override func firstPlatformOffset() -> CGFloat {
        // no offset for first level
        return 0.0
    }
}
