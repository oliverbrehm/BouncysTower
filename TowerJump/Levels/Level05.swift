//
//  Level05.swift
//  TowerJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level05 : Level
{
    override func Color() -> SKColor {
        return SKColor.orange
    }
    
    override func PlatformMinFactor() -> CGFloat
    {
        return 0.3
    }
    
    override func PlatformMaxFactor() -> CGFloat
    {
        return 0.5
    }
    
    override func GameSpeed() -> CGFloat {
        return 100.0
    }
}
