//
//  MainGame.swift
//  TowerJump
//
//  Created by Oliver Brehm on 30.01.19.
//  Copyright © 2019 Oliver Brehm. All rights reserved.
//

import SpriteKit

class MainGame: Game {
    
    public let gameOverOverlay = OverlayGameOver()
    public let extralifeOverlay = OverlayExtralife()
    
    public var scoreLabel = Button(caption: "")
    public var currentScore = 0
    
    override func Setup() {
        self.cameraNode.addChild(self.gameOverOverlay)
        self.gameOverOverlay.Setup(game: self)
        self.gameOverOverlay.Hide()
        
        self.cameraNode.addChild(self.extralifeOverlay)
        self.extralifeOverlay.Setup(game: self)
        self.extralifeOverlay.Hide()
        
        self.scoreLabel = Button(caption: "0", size: CGSize(width: World.WALL_WIDTH, height: 30.0), fontSize: 12.0, fontColor: SKColor.black, backgroundColor: SKColor.init(white: 1.0, alpha: 0.8), pressedColor: SKColor.white)
        self.scoreLabel.zPosition = NodeZOrder.Overlay
        self.scoreLabel.position = CGPoint(
            x: -world.Width / 2.0 + scoreLabel.frame.size.width / 2.0,
            y: world.Height / 2.0 - scoreLabel.frame.size.height / 2.0)
        self.cameraNode.addChild(self.scoreLabel)
    }
    
    override func ResetGame() {
        super.ResetGame()
        
        self.gameOverOverlay.Hide()
        self.extralifeOverlay.Hide()
        
        // first platforms
        for _ in 0..<8 {
            self.world.SpawnPlatform()
        }
        
        self.currentScore = 0
        self.scoreLabel.SetText(text: "0")
    }
    
    override func updateGame(_ dt: TimeInterval) {
        if(gameState == .Started || gameState == .Running)
        {
            self.cameraNode.UpdateGame(gameScene: self, player: player, world: world)
            self.world.SpawnPlatformsAbove(y: self.player.position.y)
        }
        
        if(gameState == .Running) {
            self.currentGameTime += dt
            self.CheckGameOver(dt: dt)
        }
    }
    
    private func CheckGameOver(dt: Double)
    {
        let advanceLine = GameOverY + (self.player.CurrentPlatform != nil ? self.player.CurrentPlatform!.Level.GameSpeed() : 0.0) * CGFloat(dt)
        let lineUnderPlayer = player.position.y - 0.7 * world.Height
        self.GameOverY = max(advanceLine, lineUnderPlayer)
        
        debugGameOver.position.y = self.GameOverY
        
        if(player.position.y + player.size.height / 2.0 < GameOverY)
        {
            if(Config.Default.HasExtralives()) {
                self.ShowExtralifeDialog()
            } else {
                self.GameOver()
            }
        }
    }
    
    public func GameOver()
    {
        print("played: \(self.currentGameTime)")
        AdvertisingController.Default.GamePlayed(gameTime: self.currentGameTime)
        
        self.gameOverOverlay.Show(score: self.player.Score)
        self.pauseButton.isHidden = true
        self.gameState = .Over
        
        self.run(SoundController.Default.GetSoundAction(action: .GameOver))
    }
    
    public func ShowExtralifeDialog() {
        self.extralifeOverlay.Show()
        self.extralifeOverlay.Start(game: self)
        
        self.gameState = .Paused
        self.pauseButton.isHidden = true
        
        self.world.isPaused = true
        self.player.isPaused = true
        self.physicsWorld.speed = 0.0
    }
    
    public func UseExtralife() {
        if(Config.Default.UseExtralive()) {
            self.Resume()
            self.player.UseExtralife()
            self.world.CurrentLevel!.EaseInSpeed()
            self.run(SoundController.Default.GetSoundAction(action: .SuperJump))
        } else {
            self.GameOver()
        }
    }
    
    func updateScore() {
        if(self.gameState != GameState.Running) {
            return
        }
        
        self.removeAllActions()
        
        self.scoreLabel.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run {
                if(self.currentScore >= self.player.Score) {
                    self.scoreLabel.removeAllActions()
                    return
                }
                
                self.currentScore = self.currentScore + 1
                self.scoreLabel.SetText(text: "\(self.currentScore)")
            },
            SKAction.wait(forDuration: 0.06)
            ])))
    }
    
    override func hitPlatform(platform: Platform) {
        self.updateScore()
    }
    
    override func hitCoin(coin: Coin) {
        self.player.Score += Coin.SCORE
        self.updateScore()
    }
}
