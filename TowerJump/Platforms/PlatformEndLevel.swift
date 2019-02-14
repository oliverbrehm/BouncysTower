//
//  PlatformEndLevel.swift
//  TowerJump
//
//  Created by Oliver Brehm on 28.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class PlatformEndLevel : Platform
{
    override func HitPlayer(player: Player) {
        player.SuperJump()
    }
    
    override func Score() -> Int {
        return 50
    }
}
