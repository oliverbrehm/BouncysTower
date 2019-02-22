//
//  SoundController.swift
//  TowerJump
//
//  Created by Oliver Brehm on 07.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

enum SoundAction {
    case coin
    case button
    case message
    case jump
    case superJump
    case gameOver
}

class SoundController {
    static let standard = SoundController()

    private let coinSound: SKAction
    private let buttonSound: SKAction
    private let messageSound: SKAction
    private let jumpSound: SKAction 
    private let superJumpSound: SKAction
    private let gameOverSound: SKAction
    
    init() {
        self.coinSound = SKAction.playSoundFileNamed("collectcoin.aif", waitForCompletion: true)
        self.buttonSound = SKAction.playSoundFileNamed("button.aif", waitForCompletion: true)
        self.messageSound = SKAction.playSoundFileNamed("message.aif", waitForCompletion: true)
        self.jumpSound = SKAction.playSoundFileNamed("jump.aif", waitForCompletion: true)
        self.superJumpSound = SKAction.playSoundFileNamed("superjump.aif", waitForCompletion: true)
        self.gameOverSound = SKAction.playSoundFileNamed("gameover.aif", waitForCompletion: true)
    }
    
    func getSoundAction(action: SoundAction) -> SKAction {
        switch(action) {
        case .coin:
            return self.coinSound
        case .button:
            return self.buttonSound
        case .message:
            return self.messageSound
        case .jump:
            return self.jumpSound
        case .superJump:
            return self.superJumpSound
        case .gameOver:
            return self.gameOverSound
        }
    }
}
