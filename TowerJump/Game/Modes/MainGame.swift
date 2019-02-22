//
//  MainGame.swift
//  TowerJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class MainGame: Game {
    
    let gameOverOverlay = OverlayGameOver()
    let extralifeOverlay = OverlayExtralife()
    
    var scoreLabel = Button(caption: "")
    var currentScore = 0
    
    private let gameOverTolerance: CGFloat = 20.0
    
    override func setup() {
        self.cameraNode.addChild(self.gameOverOverlay)
        self.gameOverOverlay.setup(game: self)
        self.gameOverOverlay.hide()
        
        self.cameraNode.addChild(self.extralifeOverlay)
        self.extralifeOverlay.setup(game: self)
        self.extralifeOverlay.hide()
        
        self.scoreLabel = Button(
            caption: "0", size: CGSize(width: World.wallWidth, height: 30.0),
            fontSize: 12.0, fontColor: SKColor.black,
            backgroundColor: SKColor.init(white: 1.0, alpha: 0.8),
            pressedColor: SKColor.white)
        self.scoreLabel.zPosition = NodeZOrder.overlay
        self.scoreLabel.position = CGPoint(
            x: -world.width / 2.0 + scoreLabel.frame.size.width / 2.0,
            y: world.height / 2.0 - scoreLabel.frame.size.height / 2.0)
        self.cameraNode.addChild(self.scoreLabel)
        
        self.player.jumpReadyTime = 0.25
    }
    
    override func resetGame() {
        super.resetGame()
        
        self.gameOverOverlay.hide()
        self.extralifeOverlay.hide()
        
        // first platforms
        for _ in 0..<8 {
            self.world.spawnPlatform()
        }
        
        self.currentScore = 0
        self.scoreLabel.setText(text: "0")
    }
    
    override func updateGame(_ dt: TimeInterval) {
        if(state.runningState == .started || state.runningState == .running) {
            self.cameraNode.updateIn(game: self, player: player, world: world)
            self.world.spawnPlatformsAbove(y: self.player.position.y)
        }
        
        if(state.runningState == .running) {
            self.state.currentGameTime += dt
            self.checkGameOver(dt: dt)
        }
    }
    
    private func checkGameOver(dt: Double) {
        let advanceLine = state.gameOverY + (self.player.currentPlatform != nil ? self.player.currentPlatform!.level.gameSpeed() : 0.0) * CGFloat(dt)
        let lineUnderPlayer = player.position.y - Game.gameOverLineUnderPlayerPercent * world.height
        self.state.gameOverY = max(advanceLine, lineUnderPlayer)
        
        if let l = self.world.currentLevel {
            self.state.gameOverY = min(self.state.gameOverY, l.position.y + l.topPlatformY())
        }
        
        if(player.position.y + player.size.height / 2.0 + gameOverTolerance < state.gameOverY) {
            self.run(SoundController.standard.getSoundAction(action: .gameOver))

            if(Config.standard.hasExtralives()) {
                self.showExtralifeDialog()
            } else {
                self.gameOver()
            }
        }
    }
    
    func gameOver() {
        AdvertisingController.Default.gamePlayed(gameTime: self.state.currentGameTime)
        
        self.gameOverOverlay.show(score: self.player.score)
        self.pauseButton.isHidden = true
        self.state.runningState = .over
    }
    
    func showExtralifeDialog() {
        self.extralifeOverlay.show()
        self.extralifeOverlay.start(game: self)
        
        self.state.runningState = .paused
        self.pauseButton.isHidden = true
        
        self.world.isPaused = true
        self.player.isPaused = true
        self.physicsWorld.speed = 0.0
    }
    
    func useExtralife() {
        if(Config.standard.useExtralive()) {
            self.resume()
            self.player.useExtralife()
            self.world.currentLevel!.easeInSpeed()
            self.run(SoundController.standard.getSoundAction(action: .superJump))
        } else {
            self.gameOver()
        }
    }
    
    func updateScore() {
        if(self.state.runningState != .running) {
            return
        }
        
        self.removeAllActions()
        
        self.scoreLabel.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run {
                if(self.currentScore >= self.player.score) {
                    self.scoreLabel.removeAllActions()
                    return
                }
                
                self.currentScore += 1
                self.scoreLabel.setText(text: "\(self.currentScore)")
            },
            SKAction.wait(forDuration: 0.06)
            ])))
    }
    
    override func hitPlatform(platform: Platform) {
        self.updateScore()
    }
    
    override func hitCoin(coin: Coin) {
        self.player.score += Coin.score
        self.updateScore()
    }
}
