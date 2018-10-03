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
    override func Color() -> SKColor {
        return SKColor.lightGray
    }
    
    override func PlatformMinFactor() -> CGFloat
    {
        return 0.5
    }
    
    override func PlatformMaxFactor() -> CGFloat
    {
        return 0.8
    }
    
    override func GameSpeed() -> CGFloat {
        return 40.0
    }
}
