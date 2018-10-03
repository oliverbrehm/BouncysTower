//
//  Level08.swift
//  TowerJump
//
//  Created by Oliver Brehm on 02.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class Level08 : Level
{
    override func Color() -> SKColor {
        return SKColor.black
    }
    
    override func PlatformMinFactor() -> CGFloat
    {
        return 0.10
    }
    
    override func PlatformMaxFactor() -> CGFloat
    {
        return 0.30
    }
    
    override func GameSpeed() -> CGFloat {
        return 130.0
    }
}
