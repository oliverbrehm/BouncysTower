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
    override func hitPlayer(player: Player) {
        player.superJump()
    }
    
    override func score() -> Int {
        return 50
    }
}
