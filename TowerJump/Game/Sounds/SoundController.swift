//
//  SoundController.swift
//  TowerJump
//
//  Created by Oliver Brehm on 07.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

enum SoundAction
{
    case Coin
    case Button
    case Message
    case Jump
    case SuperJump
    case GameOver
}

class SoundController {
    public static let Default = SoundController()

    private let coinSound: SKAction
    private let buttonSound: SKAction
    private let messageSound: SKAction
    private let jumpSound: SKAction
    private let superJumpSound: SKAction
    private let gameOverSound: SKAction
    
    public init() {
        self.coinSound = SKAction.playSoundFileNamed("coin.aif", waitForCompletion: true)
        self.buttonSound = SKAction.playSoundFileNamed("button.aif", waitForCompletion: true)
        self.messageSound = SKAction.playSoundFileNamed("message.aif", waitForCompletion: true)
        self.jumpSound = SKAction.playSoundFileNamed("jump.aif", waitForCompletion: true)
        self.superJumpSound = SKAction.playSoundFileNamed("superjump.aif", waitForCompletion: true)
        self.gameOverSound = SKAction.playSoundFileNamed("gameover.aif", waitForCompletion: true)
    }
    
    public func GetSoundAction(action: SoundAction) -> SKAction {
        switch(action) {
        case .Coin:
            return self.coinSound
        case .Button:
            return self.buttonSound
        case .Message:
            return self.messageSound
        case .Jump:
            return self.jumpSound
        case .SuperJump:
            return self.superJumpSound
        case .GameOver:
            return self.gameOverSound
        }
    }
}
