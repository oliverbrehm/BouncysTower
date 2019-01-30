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
    public func UpdateGame(gameScene: Game, player: Player, world: World)
    {
        self.position.y = gameScene.GameOverY + 0.5 * world.Height
    }
    
    public func UpdateTutorial(player: Player, world: World) {
        self.position.y = max(world.AbsoluteZero() + 0.5 * world.Height, player.position.y)
    }
}
