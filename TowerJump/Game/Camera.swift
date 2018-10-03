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
    public func Update(gameScene: Game, player: Player, world: World)
    {
        self.position.y = gameScene.GameOverY + 0.5 * world.Height
    }
}
