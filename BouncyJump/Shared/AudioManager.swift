//
//  SoundController.swift
//  BouncyJump
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

enum BackgroundMusic: String, CaseIterable {
    case menu
    case level
}

class AudioManager {
    static let standard = AudioManager()
    
    private var sounds: [SoundAction: SKAction] = [:]
    private var audioPlayers: [BackgroundMusic: AVAudioPlayer] = [:]
    private var currentAudioPlayer: AVAudioPlayer?
    private var currentBackgroundMusic: BackgroundMusic?
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            NSLog("Error configuring AVAudioSession, error: \(error.localizedDescription)")
        }
        
        for soundAction in SoundAction.allCases {
            sounds[soundAction] = SKAction.playSoundFileNamed(soundAction.soundFileName, waitForCompletion: true)
        }
        
        for backgroundMusic in BackgroundMusic.allCases {
            do {
                if let url = Bundle.main.url(forResource: backgroundMusic.rawValue, withExtension: "mp3"){
                    let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                    player.numberOfLoops = -1 // play indefinitely
                    audioPlayers[backgroundMusic] = player
                }
            } catch let error {
                print("Error initializing AVAudioPlayer for background music named \(backgroundMusic.rawValue), error: \(error.localizedDescription)")
            }
        }
    }
    
    func getSoundAction(action: SoundAction) -> SKAction {
        return self.sounds[action] ?? SKAction.wait(forDuration: 0.0)
    }
    
    var userAudioPlaying: Bool {
        return AVAudioSession.sharedInstance().isOtherAudioPlaying
    }
    
    func playBackgroundMusic(backgroundMusic: BackgroundMusic) {
        if userAudioPlaying {
            currentAudioPlayer?.stop()
            return
        }
        
        if let current = currentBackgroundMusic, current == backgroundMusic {
            return
        }
        
        currentAudioPlayer?.stop()
        currentAudioPlayer?.currentTime = 0
        
        if let audioPlayer = audioPlayers[backgroundMusic] {
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            currentAudioPlayer = audioPlayer
            currentBackgroundMusic = backgroundMusic
        }
    }
    
    func checkMusicAfterReturningToApp() {
        if userAudioPlaying {
            currentAudioPlayer?.stop()
        } else {
            currentAudioPlayer?.play()
        }
    }
}
