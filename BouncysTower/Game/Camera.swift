//
//  Camera.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 01.10.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Camera: SKCameraNode {
    func updateIn(game: Game, player: Player, world: World) {
        self.position.y = max(
            game.state.gameOverY + 0.5 * world.height,
            player.position.y - (Game.gameOverLineUnderPlayerPercent - 0.5) * world.height
        )
    }
}
