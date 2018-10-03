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
    override func Color() -> SKColor {
        return SKColor.darkGray
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
