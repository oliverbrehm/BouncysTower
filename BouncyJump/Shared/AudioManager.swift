//
//  SoundController.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 07.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

enum SoundAction: CaseIterable, Hashable {
    case coin
    case button
    case message
    case jump
    case superJump
    case gameOver
    case brick(type: Brick)
    case collectExtralife
    case cheer
    
    static var allCases: [SoundAction] {
        var cases: [SoundAction] = [.coin, .button, .message, .jump, .superJump, .gameOver, .collectExtralife, .cheer]
        for brick in Brick.allCases {
            cases.append(.brick(type: brick))
        }
        return cases
    }
    
    var soundFileName: String {
        switch self {
        case .coin:
            return "collectcoin.aif"
        case .button:
            return "button.aif"
        case .message:
            return "message.aif"
        case .jump:
            return "jump.aif"
        case .superJump:
            return "superjump.aif"
        case .gameOver:
            return "gameover.aif"
        case .collectExtralife:
            return "extralife.aif"
        case .cheer:
            return "cheer.aif"
        case .brick(let brick):
            return brick.soundName
        }
    }
}

class AudioController {
    static let standard = AudioController()
    
    private var sounds: [SoundAction: SKAction] = [:]
    
    init() {
        for soundAction in SoundAction.allCases {
            sounds[soundAction] = SKAction.playSoundFileNamed(soundAction.soundFileName, waitForCompletion: true)
        }
    }
    
    func getSoundAction(action: SoundAction) -> SKAction {
        return self.sounds[action] ?? SKAction.wait(forDuration: 0.0)
    }
}
