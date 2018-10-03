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
    override func Color() -> SKColor {
        return SKColor.yellow
    }
    
    override func PlatformMinFactor() -> CGFloat
    {
        return 0.20
    }
    
    override func PlatformMaxFactor() -> CGFloat
    {
        return 0.35
    }
    
    override func GameSpeed() -> CGFloat {
        return 120.0
    }
}
