//
//  PerfectJumpDetector.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 15.02.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class PerfectJumpDetector {
    
    // constants
    private let minimumRotation: CGFloat = 4.0
    private let maximumTimeOnPlatform: TimeInterval = 0.8
    
    // nodes
    private var player: Player?
    private var currentPlatform: Platform?
    
    // state
    //private var rotationOnLanding: CGFloat = 0.0 // TODO REMOVE
    private var lastPlatformNumber = -1
    private var perfectJumpPossible = false
    private var timeOnPlatform: TimeInterval = 0.0
    private var hitWallSinceJump = false
    
    // actions
    private let shakeAction: SKAction
    private let perfectJumpAction: SKAction
    
    private(set) var comboCount = 0
    var scoreMultiplicator: Int {
        return max(comboCount, 1)
    }
    
    init() {
        let shakesDuration = 0.3
        let nShakes = 2
        let halfShakeDuration = shakesDuration / Double(nShakes) / 2.0
        let shakeSize = 0.4
        
        self.shakeAction =
            SKAction.sequence([
                SKAction.rotate(byAngle: CGFloat(shakeSize / 2.0), duration: halfShakeDuration),
                SKAction.repeat(SKAction.sequence([
                    SKAction.rotate(byAngle: CGFloat(-shakeSize), duration: halfShakeDuration),
                    SKAction.rotate(byAngle: CGFloat(shakeSize), duration: halfShakeDuration)
                ]), count: nShakes - 1),
                SKAction.rotate(byAngle: CGFloat(-shakeSize / 2.0), duration: halfShakeDuration)
            ])
        
        self.perfectJumpAction = SKAction.sequence([
            SKAction.scale(to: 1.0, duration: 0.1),
            SKAction.group([
                shakeAction,
                SKAction.scale(to: 8.0, duration: 0.4),
                SKAction.fadeOut(withDuration: 0.4)
                ]),
            SKAction.removeFromParent()
        ])
    }
    
    func setup(player: Player) {
        self.player = player
        self.reset()
    }
    
    func reset() {
        self.comboCount = 0
    }
    
    func playerLandedOnPlatform(_ platform: Platform) {
        self.currentPlatform = platform
        self.timeOnPlatform = 0.0
        
        // player must have hit wall and jumped at least 2 platforms at once
        let hasJumpedMinPlatforms = platform.platformNumber >= self.lastPlatformNumber + 2
        self.perfectJumpPossible = self.hitWallSinceJump && hasJumpedMinPlatforms
        
        Logger.standard.perfectJumpState(message: "LAND. possible: \(self.perfectJumpPossible), min2platforms: \(hasJumpedMinPlatforms), hitWall: \(hitWallSinceJump)")
        
        self.hitWallSinceJump = false
    }
    
    func playerHitWall() {
        self.hitWallSinceJump = true
    }
    
    func playerLeftPlatform() {
        Logger.standard.perfectJumpState(message: "LEFT. possible: \(self.perfectJumpPossible)")

        if(self.perfectJumpPossible && self.timeOnPlatform < self.maximumTimeOnPlatform) {
            // perfect jump done
            self.comboCount += 1
            if(self.comboCount >= 0) {
                self.showPerfectJumpDone()
            }
        } else {
            if(self.comboCount > 1) {
                self.showComboFinished()
            }
            self.comboCount = -1
        }
        
        self.lastPlatformNumber = self.currentPlatform?.platformNumber ?? -1
        self.currentPlatform = nil
        self.perfectJumpPossible = false
    }
    
    func update(dt: TimeInterval) {
        self.timeOnPlatform += dt
    }
    
    private func showPerfectJumpDone() {
        if let p = self.player {
            let comboLabel = SKLabelNode(fontNamed: Constants.fontName)
            comboLabel.zPosition = NodeZOrder.consumable
            comboLabel.fontSize = min(14.0 + CGFloat(2 * self.comboCount), 50.0) // bigger label with bigger combo
            comboLabel.color = SKColor.darkGray
            comboLabel.fontColor = self.getColorForComboCount()
            comboLabel.alpha = 0.8
            comboLabel.setScale(0.0)
            
            comboLabel.position = p.position
            comboLabel.text = self.comboCount >= 2 ? "x \(self.comboCount)"
                : (self.comboCount == 0 ? "Perfect!" : "AWESOME")
            
            if let w = p.world {
                w.addChild(comboLabel)
                comboLabel.run(self.perfectJumpAction)
            }
        }
    }
    
    private func showComboFinished() {
        if let c = self.player?.scene?.camera {
            let comboFinishedLabel = SKLabelNode(fontNamed: Constants.fontName)
            comboFinishedLabel.zPosition = NodeZOrder.consumable
            comboFinishedLabel.fontSize = 32.0
            comboFinishedLabel.color = SKColor.darkGray
            comboFinishedLabel.fontColor = Constants.colors.menuForeground
            
            comboFinishedLabel.position = CGPoint.zero
            comboFinishedLabel.text = "!!COMBO: \(self.comboCount)!!"
            
            let particelEmitter = SKEmitterNode(fileNamed: "ComboParticle")!
            particelEmitter.targetNode = self.player?.scene
            particelEmitter.particleBirthRate = comboCount >= 10 ? min(CGFloat(50 * self.comboCount), 2000.0) : 0.0
            particelEmitter.position = CGPoint(x: 0.0, y: -(self.player?.scene?.frame.size.height ?? 0.0) / 2.0)
            c.addChild(particelEmitter)
            
            if(self.comboCount >= 10) {
                self.player!.scene!.run(SoundController.standard.getSoundAction(action: .cheer))
            }
            
            c.addChild(comboFinishedLabel)
            comboFinishedLabel.run(SKAction.sequence([
                SKAction.group([
                    SKAction.fadeIn(withDuration: 0.1),
                    SKAction.moveBy(x: 0.0,
                                    y: (self.player?.scene?.size.height ?? 0.0) / 2.0 - 2 * comboFinishedLabel.frame.size.height, duration: 0.2),
                    self.shakeAction
                ]),
                SKAction.wait(forDuration: 0.25),
                SKAction.fadeOut(withDuration: 0.2),
                SKAction.removeFromParent(),
                SKAction.run {
                    particelEmitter.particleBirthRate = 0.0
                },
                SKAction.wait(forDuration: 2.0),
                SKAction.run {
                    particelEmitter.removeFromParent()
                }
            ]))
        }
    }
    
    private func getColorForComboCount() -> SKColor {
        // color dependent on _comboCount
        // TODO the bigger the brighter
        return SKColor.green
    }
}
