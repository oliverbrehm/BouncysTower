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
    override func Color() -> SKColor {
        return SKColor.green
    }
    
    override func PlatformMinFactor() -> CGFloat
    {
        return 0.35
    }
    
    override func PlatformMaxFactor() -> CGFloat
    {
        return 0.7
    }
    
    override func GameSpeed() -> CGFloat {
        return 80.0
    }
}
