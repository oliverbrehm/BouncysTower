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
    override func Color() -> SKColor {
        return SKColor.white
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
