//
//  GameScene.swift
//  TowerJump
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameState {
    case Started
    case Running
    case Paused
    case Over
}

class Game: SKScene, SKPhysicsContactDelegate {
    public var GameOverY : CGFloat = 0.0
    
    private var gameState = GameState.Started
    
    private var lastTime : TimeInterval = -1.0
    private var lastDebug : TimeInterval = 0.0;
    
    private var lastX : CGFloat = 0.0;
        
    private let player = Player()
    private let world = World()
    private let cameraNode = Camera()
    private let background = SKSpriteNode.init(color: SKColor.black, size: CGSize.zero)
    
    private let gameOverOverlay = OverlayGameOver()
    private let pausedOverlay = OverlayPause()
    private let extralifeOverlay = OverlayExtralife()
    private var pauseButton = Button(caption: "")
    
    private var scoreLabel = Button(caption: "")
    private var currentScore = 0
    
    public var GameViewController : GameViewController?
    
    private var timeWasPaused = false // after game paused do not calculate time delta
    
    private var numberOfLives = 0
    
    private static let VISUAL_DEBUG = false
    let debugLabel = SKLabelNode(text: "DEBUG")
    var debugGameOver : SKSpriteNode = SKSpriteNode(color: SKColor.red, size: CGSize.zero)
    var debugLeft : SKSpriteNode = SKSpriteNode(color: SKColor.red, size: CGSize.zero)
    var debugRight : SKSpriteNode = SKSpriteNode(color: SKColor.red, size: CGSize.zero)
    
    override func sceneDidLoad() {
        self.backgroundColor = SKColor.white
    }
    
    override func didMove(to view: SKView) {
        if(player.parent == nil) {
            self.physicsWorld.contactDelegate = self
            
            self.player.Initialize(world: self.world, scene: self)
            
            self.camera = cameraNode
            self.addChild(cameraNode)
            
            self.background.size = self.size
            self.cameraNode.addChild(self.background)
            
            self.addChild(world)
            self.addChild(player)
            
            ResetGame()

            self.cameraNode.addChild(self.gameOverOverlay)
            self.gameOverOverlay.Setup(game: self)
            self.gameOverOverlay.Hide()
            
            self.cameraNode.addChild(self.pausedOverlay)
            self.pausedOverlay.Setup(game: self)
            self.gameOverOverlay.Hide()
            
            self.cameraNode.addChild(self.extralifeOverlay)
            self.extralifeOverlay.Setup(game: self)
            self.extralifeOverlay.Hide()
            
            let buttonsColor = SKColor.init(white: 1.0, alpha: 0.8)
            
            self.pauseButton = Button(caption: "||", size: CGSize(width: World.WALL_WIDTH, height: 30.0), fontSize: 18.0, fontColor: SKColor.black, backgroundColor: buttonsColor, pressedColor: SKColor.white)
            self.pauseButton.Action = {
                self.Pause()
            }
            self.pauseButton.zPosition = NodeZOrder.Overlay
            self.pauseButton.position = CGPoint(
                x: world.Width / 2.0 - pauseButton.frame.size.width / 2.0,
                y: world.Height / 2.0 - pauseButton.frame.size.height / 2.0)
            self.cameraNode.addChild(self.pauseButton)
            
            self.scoreLabel = Button(caption: "0", size: CGSize(width: World.WALL_WIDTH, height: 30.0), fontSize: 12.0, fontColor: SKColor.black, backgroundColor: buttonsColor, pressedColor: SKColor.white)
            self.scoreLabel.zPosition = NodeZOrder.Overlay
            self.scoreLabel.position = CGPoint(
                x: -world.Width / 2.0 + scoreLabel.frame.size.width / 2.0,
                y: world.Height / 2.0 - scoreLabel.frame.size.height / 2.0)
            self.cameraNode.addChild(self.scoreLabel)
            
            if(Game.VISUAL_DEBUG)
            {
                debugLabel.position = CGPoint(x: 0.0, y: self.size.height / 2.0 - 30.0)
                debugLabel.fontColor = SKColor.red
                debugLabel.fontSize = 50
                //self.addChild(debugLabel)
                
                debugGameOver.size = CGSize(width: self.frame.width, height: 2.0)
                self.addChild(debugGameOver)
                
                debugLeft.size = CGSize(width: 2.0, height: self.frame.height - 5.0)
                self.addChild(debugLeft)
                
                debugRight.size = CGSize(width: 2.0, height: self.frame.height - 5.0)
                self.addChild(debugRight)
            }
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        self.player.StartMoving()
        lastX = pos.x
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let dx = pos.x - lastX
        
        player.Move(x: dx)
        
        lastX = pos.x
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if(gameState == .Started || gameState == .Running) {
            player.Jump()
        }
        
        if(gameState == .Started) {
            gameState = .Running
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if(lastTime < 0.0) {
            lastTime = currentTime
        }
        var dt = currentTime - lastTime
        if(self.timeWasPaused) {
            dt = 0.0
            self.timeWasPaused = false
        }

        if(gameState == .Started || gameState == .Running)
        {
            self.cameraNode.Update(gameScene: self, player: player, world: world)
            world.UpdateWallY(player.position.y)
            self.showDebugText(text: "goy: \(GameOverY)", currentTime: currentTime, pause: true)
        }
        
        if(gameState == .Running) {
            player.Update()
                        
            self.CheckGameOver(dt: dt)
        }
        
        lastTime = currentTime
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
    
    func showDebugText(text: String, currentTime: TimeInterval, pause: Bool)
    {
        if(pause && currentTime - lastDebug < 0.1)
        {
            return
        }
        
        self.debugLabel.text = text
        self.debugLabel.position.x = 20.0 - world.Width / 2.0 + self.debugLabel.frame.width / 2.0
        self.debugLabel.position.y = self.camera!.position.y
        debugLeft.position = CGPoint(x: -world.Width / 2.0 + 2.0, y: camera!.position.y)
        debugRight.position = CGPoint(x: world.Width / 2.0 - 2.0, y: camera!.position.y)
        
        lastDebug = currentTime
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(player.State == .Falling && (contact.bodyA.node is Platform || contact.bodyB.node is Platform))
        {
            let platform = contact.bodyA.node is Platform ? contact.bodyA.node as! Platform : contact.bodyB.node as! Platform
            player.LandOnPlatform(platform: platform)
            world.LandOnPlatform(platform: platform, player: player)
            self.updateScore()
        } else if(contact.bodyA.node?.name == "Wall" || contact.bodyB.node?.name == "Wall") {
            player.HitWall()
        } else if(contact.bodyA.node is Coin || contact.bodyB.node is Coin) {
            let coin = (contact.bodyA.node is Coin ? contact.bodyA.node : contact.bodyB.node) as! Coin
            coin.hit()
            self.player.Score += Coin.SCORE
            self.updateScore()
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
    
    public func GameOver()
    {
        self.gameOverOverlay.Show(score: self.player.Score)
        self.pauseButton.isHidden = true
        self.gameState = .Over
    }
    
    public func UseExtralife() {
        if(Config.Default.UseExtralive()) {
            self.player.position = CGPoint(x: 0.0, y: self.player.position.y + 300.0)
            self.player.zRotation = 0.0
            self.player.physicsBody?.velocity = CGVector.zero
            self.world.CurrentLevel.EaseInSpeed()
            self.Resume()
        } else {
            self.GameOver()
        }
    }
    
    public func ResetGame()
    {
        self.Resume()

        debugLeft.position = CGPoint(x: -world.Width / 2.0 + 2.0, y: camera!.position.y)
        debugRight.position = CGPoint(x: world.Width / 2.0 - 2.0, y: camera!.position.y)
        
        world.Create(self)
        self.GameOverY = world.AbsoluteZero()
        debugGameOver.position.y = self.GameOverY
        
        self.gameState = .Started
        self.gameOverOverlay.Hide()
        self.pauseButton.isHidden = false
        
        self.world.isPaused = false
        self.player.isPaused = false
        self.pauseButton.isHidden = false
        self.pausedOverlay.Hide()
        self.extralifeOverlay.Hide()
        
        self.player.Reset()
        self.player.position = CGPoint(x: 0.0, y: world.AbsoluteZero() + player.size.height / 2.0)
        
        self.currentScore = 0
        self.scoreLabel.SetText(text: "0")
    }
    
    public func Pause()
    {
        self.pausedOverlay.Show()
        self.gameState = .Paused
        self.pauseButton.isHidden = true 
        
        self.world.isPaused = true
        self.player.isPaused = true
        self.physicsWorld.speed = 0.0
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
    
    public func Resume()
    {
        self.pausedOverlay.Hide()
        self.gameState = .Running
        self.pauseButton.isHidden = false
        self.timeWasPaused = true
        
        self.world.isPaused = false
        self.player.isPaused = false
        self.physicsWorld.speed = 1.0
    }
    
    public func LevelReached(level: Level) {
        self.background.run(SKAction.colorize(with: level.BackgroundColor(), colorBlendFactor: 0.6, duration: 0.5))
    }
}
