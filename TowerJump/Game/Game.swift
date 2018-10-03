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
    
    private var score = 0
    
    private let player = Player()
    private let world = World()
    private let cameraNode = Camera()
    
    private let gameOverOverlay = OverlayGameOver()
    private let pausedOverlay = OverlayPause()
    private var pauseButton = Button(caption: "")
    
    public var GameViewController : GameViewController?
    
    private var timeWasPaused = false // after game paused do not calculate time delta
    
    private static let VISUAL_DEBUG = false
    let debugLabel = SKLabelNode(text: "DEBUG")
    var debugGameOver : SKSpriteNode = SKSpriteNode(color: SKColor.red, size: CGSize.zero)
    var debugLeft : SKSpriteNode = SKSpriteNode(color: SKColor.red, size: CGSize.zero)
    var debugRight : SKSpriteNode = SKSpriteNode(color: SKColor.red, size: CGSize.zero)
    
    override func sceneDidLoad() {
        
    }
    
    override func didMove(to view: SKView) {
        if(player.parent == nil) {
            self.physicsWorld.contactDelegate = self
            
            self.player.World = self.world
            
            self.camera = cameraNode
            self.addChild(cameraNode)
            
            resetGame()
            
            self.addChild(world)
            self.addChild(player)
            
            self.gameOverOverlay.size = CGSize(
                width: self.frame.size.width * 0.6,
                height: self.frame.size.height * 0.9)
            self.gameOverOverlay.Game = self
            self.cameraNode.addChild(self.gameOverOverlay)
            
            self.pausedOverlay.size = CGSize(
                width: self.frame.size.width * 0.6,
                height: self.frame.size.height * 0.9)
            self.pausedOverlay.Game = self
            self.cameraNode.addChild(self.pausedOverlay)
            
            self.pauseButton = Button(caption: "Pause", size: CGSize(width: 60.0, height: 30.0), fontSize: 16.0, fontColor: SKColor.red, backgroundColor: SKColor.darkGray, pressedColor: SKColor.white)
            self.pauseButton.Action = {
                self.Pause()
            }
            self.pauseButton.zPosition = NodeZOrder.Overlay
            self.pauseButton.position = CGPoint(
                x: world.Width / 2.0 - pauseButton.frame.size.width / 2.0 - 5.0 ,
                y: world.Height / 2.0 - pauseButton.frame.size.height / 2.0 - 5.0)
            self.cameraNode.addChild(self.pauseButton)
            
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
        let advanceLine = GameOverY + self.world.CurrentLevel.GameSpeed() * CGFloat(dt)
        let lineUnderPlayer = player.position.y - 0.7 * world.Height
        self.GameOverY = max(advanceLine, lineUnderPlayer)

        debugGameOver.position.y = self.GameOverY
        
        if(player.position.y + player.size.height / 2.0 < GameOverY)
        {
            gameOver()
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
            
            if(platform.PlatformNumber > self.score) {
                self.score = platform.PlatformNumber
            }
        } else if(contact.bodyA.node?.name == "Wall" || contact.bodyB.node?.name == "Wall") {
            player.HitWall()
        }
    }
    
    private func gameOver()
    {
        self.gameOverOverlay.Show(score: self.score)
        self.pauseButton.isHidden = true
        self.gameState = .Over
    }
    
    public func resetGame()
    {
        self.score = 0
        
        debugLeft.position = CGPoint(x: -world.Width / 2.0 + 2.0, y: camera!.position.y)
        debugRight.position = CGPoint(x: world.Width / 2.0 - 2.0, y: camera!.position.y)
        
        world.Create(self)
        self.GameOverY = world.AbsoluteZero()
        debugGameOver.position.y = self.GameOverY
        
        self.gameState = .Started
        self.gameOverOverlay.Hide()
        self.pauseButton.isHidden = false
        
        self.scene?.isPaused = false
        self.pauseButton.isHidden = false
        self.pausedOverlay.Hide()
        
        self.player.Reset()
        player.position = CGPoint(x: 0.0, y: world.AbsoluteZero() + player.size.height / 2.0)
    }
    
    public func Pause()
    {
        self.pausedOverlay.Show()
        self.gameState = .Paused
        self.scene?.isPaused = true
        self.pauseButton.isHidden = true
    }
    
    public func Resume()
    {
        self.pausedOverlay.Hide()
        self.gameState = .Running
        self.scene?.isPaused = false
        self.pauseButton.isHidden = false
        self.timeWasPaused = true
    }
}
