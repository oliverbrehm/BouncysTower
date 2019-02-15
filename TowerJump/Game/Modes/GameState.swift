//
//  GameState.swift
//  TowerJump iOS
//
//  Created by Oliver Brehm on 15.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

enum RunningState {
    case started
    case running
    case paused
    case over
}

class GameState {
    var runningState = RunningState.started
    var numberOfLives = 0
    var allowJump = true
    var lastTime : TimeInterval = -1.0
    var timeWasPaused = false // after game paused do not calculate time delta
    var currentGameTime: TimeInterval = 0.0
    var GameOverY : CGFloat = 0.0
}
