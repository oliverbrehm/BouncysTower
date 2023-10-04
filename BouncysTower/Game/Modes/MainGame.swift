//
//  MainGame.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class ScoreLabel: SKSpriteNode {
    var scoreLabel = SKLabelNode(fontNamed: Font.fontName)
    var multiplicatorLabel = SKLabelNode(fontNamed: Font.fontName)
    
    init() {
        super.init(texture: SKTexture(imageNamed: "scorebg"), color: Colors.menuForeground, size: CGSize.zero)
        
        self.colorBlendFactor = 1.0
        self.zPosition = NodeZOrder.overlay
        self.updateCenterRect()
        
        self.scoreLabel.fontSize = 14.0
        self.scoreLabel.fontColor = Colors.overlay

        self.text = "0"

        self.scoreLabel.zPosition = NodeZOrder.label
        self.scoreLabel.position = CGPoint(x: 0.0, y: -self.scoreLabel.frame.size.height / 2.0)
        self.addChild(self.scoreLabel)
        
        self.multiplicatorLabel.text = "x 1"
        self.multiplicatorLabel.fontSize = 12.0
        self.multiplicatorLabel.fontColor = Colors.menuForeground
        self.multiplicatorLabel.zPosition = NodeZOrder.label
        self.multiplicatorLabel.position =
            CGPoint(x: 0.0, y: -self.size.height / 2.0 - 5.0 - multiplicatorLabel.frame.size.height / 2.0)
        self.addChild(multiplicatorLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(texture: nil, color: SKColor.white, size: CGSize.zero)
    }
    
    private var text: String {
        get {
            return self.scoreLabel.text ?? ""
        }
        set {
            self.scoreLabel.text = newValue
            let quant = 20 // quantization by
            let size = self.scoreLabel.frame.size.width * 1.2
            let n = Int(size) / quant
            let newWidth = CGFloat((n + 1) * quant)
            self.size = CGSize(width: newWidth, height: self.scoreLabel.frame.size.height * 2.0)
            self.updateCenterRect()
        }
    }
    
    func reset() {
        self.text = "0"
        
        let personalTowerHeight = TowerBricks.standard.rows.count
        multiplicatorLabel.text = personalTowerHeight > 1 ? "x \(personalTowerHeight)" : ""
    }
    
    func update(text: String) {
        self.text = text
    }
    
    private func updateCenterRect() {
        self.centerRect = CGRect(x: 0.4, y: 0.4, width: 0.2, height: 0.2)
    }
}

class MainGame: Game {
    
    let gameOverOverlay = OverlayGameOver()
    let extralifeOverlay = OverlayExtralife()
    
    let scoreLabel = ScoreLabel()
    
    var currentScore = 0
    
    private let gameOverTolerance: CGFloat = 20.0
    private let keyUpdateScoreAction = "ACTION_UPDATE_SCORE"
    
    override func setup() {
        self.cameraNode.addChild(self.gameOverOverlay)
        self.gameOverOverlay.setup(game: self)
        self.gameOverOverlay.hide()
        
        self.cameraNode.addChild(self.extralifeOverlay)
        self.extralifeOverlay.setup(game: self)
        self.extralifeOverlay.hide()
        
        self.cameraNode.addChild(self.scoreLabel)
        
        self.scoreLabel.reset()
        self.updateScorePosition()
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
        self.scoreLabel.reset()
        self.updateScorePosition()
    }
    
    override func updateGame(_ dt: TimeInterval) {
        if state.runningState == .running {
            self.cameraNode.updateIn(game: self, player: player, world: world)
            self.world.spawnPlatformsAbove(y: self.player.position.y)
        }
        
        if state.runningState == .running {
            self.state.currentGameTime += dt
            self.checkGameOver(dt: dt)
        }
    }
    
    private func checkGameOver(dt: Double) {
        let advanceLine = state.gameOverY + (self.player.currentPlatform != nil ? self.player.currentPlatform!.level.gameSpeed : 0.0) * CGFloat(dt)
        let lineUnderPlayer = player.position.y - Game.gameOverLineUnderPlayerPercent * world.height
        self.state.gameOverY = max(advanceLine, lineUnderPlayer)
        
        if let l = self.world.currentLevel {
            self.state.gameOverY = min(self.state.gameOverY, l.position.y + l.topPlatformY)
        }
        
        if player.position.y + player.size.height / 2.0 + gameOverTolerance < state.gameOverY {
            player.died()
            
            if Config.standard.hasExtralives() {
                self.run(SoundAction.gameOver.action)
                self.showExtralifeDialog()
            } else {
                self.gameOver()
            }
        }
    }
    
    func gameOver() {
        AdvertisingController.shared.gamePlayed(gameTime: self.state.currentGameTime)
        
        AudioManager.standard.playBackgroundMusic(backgroundMusic: .gameover)
        
        let score = self.player.score
        let rank = score > 0 ? Score.standard.addScore(score) : nil
        
        let platformNumber = player.currentPlatform?.platformNumber ?? 0
        let longestCombo = player.longestCombo
        
        let bestPlatformNumber = platformNumber > Score.standard.highestJump
        let bestCombo = longestCombo > Score.standard.longestCombo
                
        Score.standard.highestJump = platformNumber
        Score.standard.longestCombo = longestCombo
        
        self.gameOverOverlay.show(
            score: score, rank: rank,
            platformNumber: platformNumber, isBestPlatformNumber: bestPlatformNumber,
            longestCombo: longestCombo, isBestCombo: bestCombo)
        
        self.pause()
        self.state.runningState = .over
        
        player.gameover()
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
        if Config.standard.useExtralive() {
            self.resume()
            self.player.useExtralife()
            self.world.currentLevel!.easeInSpeed()
            self.run(SoundAction.collectExtralife.action)
        } else {
            self.gameOver()
        }
    }
    
    func updateScore() {
        if self.state.runningState != .running {
            return
        }
        
        self.removeAction(forKey: keyUpdateScoreAction)
        
        self.scoreLabel.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run {
                if self.currentScore >= self.player.score {
                    self.scoreLabel.removeAction(forKey: self.keyUpdateScoreAction)
                    return
                }
                
                let dif = self.player.score - self.currentScore
                let step = dif <= 50 ? 1 : dif / 10 - 1
                
                self.currentScore += step
                self.scoreLabel.update(text: "\(self.currentScore)")
                self.updateScorePosition()
            },
            SKAction.wait(forDuration: 0.02)
            ])), withKey: self.keyUpdateScoreAction)
    }
    
    func updateScorePosition() {
        self.scoreLabel.position = CGPoint(
            x: -world.width / 2.0 + scoreLabel.size.width / 2.0 + Config.roundedDisplayMargin + 5.0,
            y: world.height / 2.0 - scoreLabel.size.height / 2.0 - Config.roundedDisplayMargin - 5.0)
    }
    
    override func hitPlatform(platform: Platform) {
        self.updateScore()
    }
    
    override func hitCoin(coin: Coin) {
        self.player.score += coin.score
        self.updateScore()
    }
}
