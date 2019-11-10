//
//  SoundController.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 07.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit
import AVFoundation

enum SoundAction: CaseIterable, Hashable {
    case coin
    case button
    case message
    case jump1
    case jump2
    case bigJump1
    case bigJump2
    case superJump
    case gameOver
    case brick(type: Brick)
    case collectExtralife
    case collectSuperCoin
    case cheer
    
    static var allCases: [SoundAction] {
        var cases: [SoundAction] = [
            .coin,
            .button,
            .message,
            .jump1,
            .jump2,
            .bigJump1,
            .bigJump2,
            .superJump,
            .gameOver,
            .collectExtralife,
            .collectSuperCoin,
            .cheer
        ]
        
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
        case .jump1:
            return "jump1.aif"
        case .jump2:
            return "jump2.aif"
        case .bigJump1:
            return "bigjump1.aif"
        case .bigJump2:
            return "bigjump2.aif"
        case .superJump:
            return "superjump.aif"
        case .gameOver:
            return "gameover.aif"
        case .collectExtralife:
            return "extralife.aif"
        case .collectSuperCoin:
            return "brick_ice.aif"
        case .cheer:
            return "cheer.aif"
        case .brick(let brick):
            return brick.soundName
        }
    }
    
    static var sounds: [SoundAction: SKAction] = {
        var sounds: [SoundAction: SKAction]  = [:]
        
        for soundAction in SoundAction.allCases {
            sounds[soundAction] = SKAction.playSoundFileNamed(soundAction.soundFileName, waitForCompletion: true)
        }
        
        return sounds
    }()
    
    var action: SKAction {
        return SoundAction.sounds[self] ?? SKAction.wait(forDuration: 0.0)
    }
    
    static var jump: SoundAction {
        return Double.random(in: 0 ..< 1) < 0.7 ? .jump1 : .jump2
    }
    
    static var bigJump: SoundAction {
        return Double.random(in: 0 ..< 1) < 0.6 ? .bigJump1 : .bigJump2
    }
}

enum BackgroundMusic: String, CaseIterable {
    case menu
    case level
    case gameover
    
    var audioPlayer: AVAudioPlayer? {
        return BackgroundMusic.audioPlayers[self]
    }
    
    static var audioPlayers: [BackgroundMusic: AVAudioPlayer] = {
        var players: [BackgroundMusic: AVAudioPlayer] = [:]
        
        for backgroundMusic in BackgroundMusic.allCases {
            do {
                if let url = Bundle.main.url(forResource: backgroundMusic.rawValue, withExtension: "mp3"){
                    let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                    player.numberOfLoops = backgroundMusic == .gameover ? 0 : -1 // play indefinitely
                    players[backgroundMusic] = player
                }
            } catch let error {
                print("Error initializing AVAudioPlayer for background music named \(backgroundMusic.rawValue), error: \(error.localizedDescription)")
            }
        }
        
        return players
    }()
}

class AudioManager {
    static let standard = AudioManager()
    
    private var currentBackgroundMusic: BackgroundMusic?
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            NSLog("Error configuring AVAudioSession, error: \(error.localizedDescription)")
        }
    }
    
    var userAudioPlaying: Bool {
        return AVAudioSession.sharedInstance().isOtherAudioPlaying
    }
    
    func playBackgroundMusic(backgroundMusic: BackgroundMusic) {
        if let current = currentBackgroundMusic {
            if current == backgroundMusic {
                playCurrentMusic()
            } else {
                stopCurrentMusic()
                currentBackgroundMusic = backgroundMusic
                playCurrentMusic()
            }
        } else {
            // no music set yet
            currentBackgroundMusic = backgroundMusic
            playCurrentMusic()
        }
    }
    
    func checkMusicAfterReturningToApp() {
        if userAudioPlaying {
            // stop without resetting play time
            currentBackgroundMusic?.audioPlayer?.stop()
        } else {
            playCurrentMusic()
        }
    }
    
    private func playCurrentMusic() {
        if let current = currentBackgroundMusic, !userAudioPlaying {
            current.audioPlayer?.prepareToPlay()
            current.audioPlayer?.play()
        }
    }
    
    private func stopCurrentMusic() {
        if let current = currentBackgroundMusic {
            current.audioPlayer?.stop()
            current.audioPlayer?.currentTime = 0
        }
    }
}
