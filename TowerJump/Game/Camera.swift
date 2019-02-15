//
//  Camera.swift
//  TowerJump
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Camera : SKCameraNode
{
    func updateIn(game: Game, player: Player, world: World)
    {
        self.position.y = max(game.State.GameOverY + 0.5 * world.height, player.position.y - (Game.GAME_OVER_LINE_UNDER_PLAYER_PERCENT - 0.5) * world.height)
    }
    
    func updateInTutorial(player: Player, world: World) {
        self.position.y = max(world.absoluteZero() + 0.5 * world.height, player.position.y)
    }
}
