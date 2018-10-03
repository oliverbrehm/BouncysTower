//
//  Level02.swift
//  TowerJump
//
//  Created by Oliver Brehm on 25.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Level02 : Level
{
    override func Color() -> SKColor {
        return SKColor.blue
    }
    
    override func PlatformMinFactor() -> CGFloat
    {
        return 0.4
    }
    
    override func PlatformMaxFactor() -> CGFloat
    {
        return 0.8
    }
    
    override func GameSpeed() -> CGFloat {
        return 60.0
    }
}
