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
    
    public var gameState = GameState.Started
    public var allowJump = true
    
    public var lastTime : TimeInterval = -1.0
    public var lastDebug : TimeInterval = 0.0;
    
    public var lastX : CGFloat = 0.0;
        
    public let player = Player()
    public let world = World()
    public let cameraNode = Camera()
    public let background = SKSpriteNode.init(color: SKColor.black, size: CGSize.zero)
    
    public let pausedOverlay = OverlayPause()
    public var pauseButton = Button(caption: "")
    
    public var GameViewController : GameViewController?
    
    public var timeWasPaused = false // after game paused do not calculate time delta
    
    public var currentGameTime: TimeInterval = 0.0
    
    public var numberOfLives = 0
    
    private static let VISUAL_DEBUG = false
    let debugLabel = SKLabelNode(text: "DEBUG")
    var debugGameOver : SKSpriteNode = SKSpriteNode(color: SKColor.red, size: CGSize.zero)
    var debugLeft : SKSpriteNode = SKSpriteNode(color: SKColor.red, size: CGSize.zero)
    var debugRight : SKSpriteNode = SKSpriteNode(color: SKColor.red, size: CGSize.zero)
    
    func Setup() {} // abstract
    func updateGame(_ dt: TimeInterval) {} // abstract
    func hitPlatform(platform: Platform) {} // abstract
    func hitCoin(coin: Coin) {} // abstract
    
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

            self.cameraNode.addChild(self.pausedOverlay)
            self.pausedOverlay.Setup(game: self)
            self.pausedOverlay.Hide()
            
            self.pauseButton = Button(caption: "||", size: CGSize(width: World.WALL_WIDTH, height: 30.0), fontSize: 18.0, fontColor: SKColor.black, backgroundColor: SKColor.init(white: 1.0, alpha: 0.8), pressedColor: SKColor.white)
            self.pauseButton.Action = {
                self.Pause()
                self.pausedOverlay.Show()
            }
            self.pauseButton.zPosition = NodeZOrder.Overlay
            self.pauseButton.position = CGPoint(
                x: world.Width / 2.0 - pauseButton.frame.size.width / 2.0,
                y: world.Height / 2.0 - pauseButton.frame.size.height / 2.0)
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
            
            self.Setup()
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
        if(self.allowJump && (gameState == .Started || gameState == .Running)) {
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
            world.UpdateWallY(player.position.y)
        }
        
        if(gameState == .Running) {
            player.Update()
        }

        self.updateGame(dt)
        
        lastTime = currentTime
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
            self.hitPlatform(platform: platform)
        } else if(contact.bodyA.node?.name == "Wall" || contact.bodyB.node?.name == "Wall") {
            player.HitWall()
        } else if(contact.bodyA.node is Coin || contact.bodyB.node is Coin) {
            let coin = (contact.bodyA.node is Coin ? contact.bodyA.node : contact.bodyB.node) as! Coin
            coin.hit()
            self.world.RemoveCoin(coin: coin)
            self.hitCoin(coin: coin)
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
        self.pauseButton.isHidden = false
        
        self.world.isPaused = false
        self.player.isPaused = false
        self.pauseButton.isHidden = false
        self.pausedOverlay.Hide()
        
        self.player.Reset()
        self.player.position = CGPoint(x: 0.0, y: world.AbsoluteZero() + player.size.height / 2.0)
        
        self.currentGameTime = 0.0
                
        AdvertisingController.Default.PresentIfNeccessary(returnScene: self.scene!, completionHandler: {})
    }
    
    public func Pause()
    {
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
