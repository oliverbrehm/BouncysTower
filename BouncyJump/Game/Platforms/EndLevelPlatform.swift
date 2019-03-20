//
//  PlatformEndLevel.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 28.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class EndLevelPlatform: Platform {
    override func setup() {
        let c1 = SKAction.colorize(with: self.backgroundColor, colorBlendFactor: 1.0, duration: 0.4)
        let c2 = SKAction.colorize(with: SKColor.red, colorBlendFactor: 1.0, duration: 0.4)
        self.run(SKAction.repeatForever(SKAction.sequence([c1, c2])))
    }
    
    override func hitPlayer(player: Player, world: World) {
        world.spawnNextLevel()
        player.nextLevelJump()
    }
    
    override func score() -> Int {
        return 50
    }
}
