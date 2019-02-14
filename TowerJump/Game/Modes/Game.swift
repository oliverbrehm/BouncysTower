//
//  GameScene.swift
//  TowerJump
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum GameState {
    case Started
    case Running
    case Paused
    case Over
}

class Game: SKScene, SKPhysicsContactDelegate {
    private var lastGravityX: CGFloat = 0.0 // TODO move elsewhere
    
    private let motionManager = CMMotionManager()
    
    public var GameOverY : CGFloat = 0.0
    
    public var gameState = GameState.Started
    public var allowJump = true
    
    public var lastTime : TimeInterval = -1.0
    public var lastDebug : TimeInterval = 0.0;
            
    public let player = Player()
    public let world = World()
    public let cameraNode = Camera()
    public let background = SKSpriteNode.init(color: SKColor.black, size: CGSize.zero)
    
    public let pausedOverlay = OverlayPause()
    public var pauseButton = Button(caption: "")
    
    public var GameViewController : GameViewController?
    
    public static let GAME_OVER_LINE_UNDER_PLAYER_PERCENT: CGFloat = 0.7
    
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
        self.backgroundColor = SKColor.black
    }
    
    override func didMove(to view: SKView) {
        if(player.parent == nil) {
            self.physicsWorld.contactDelegate = self
            
            self.player.Initialize(world: self.world, scene: self)
            
            self.camera = cameraNode
            self.addChild(cameraNode)
            
            self.background.size = self.size
            self.background.zPosition = NodeZOrder.Background
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
            
            self.motionManager.startDeviceMotionUpdates()
            
            self.Setup()
        }
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
        
        // TODO remove, experimental motion control
        /* if(self.motionManager.isDeviceMotionAvailable) {
            if let g = self.motionManager.deviceMotion?.gravity {
                if(abs(g.y) > 0.05) {
                    var dx = CGFloat(g.y)
                    if(abs(dx) > 0.2) {
                        dx = dx > 0 ? 0.2 : -0.2
                    }
                    dx = dx * CGFloat(dt) * 2400 * (UIDevice.current.orientation == UIDeviceOrientation.landscapeRight ? 1 : -1)
                    
                    if(abs(dx) >= abs(self.lastGravityX)) {
                        self.player.Move(x: dx)
                    } else {
                        self.player.NeutralizeHorizontalSpeed()
                    }
                    
                    self.lastGravityX = dx
                }
                //var gravity = CGVector(dx: 0.0, dy: -1.0)
                // self.updateGravity(gravity.normalized() * 9.81)
                // print(String(format: "g: %.2f, %.2f, %.2f", g.x, g.y, g.z))
                print(String(format: "g: %.2f", g.y))
            }
        }*/
        
        lastTime = currentTime
    }
    
    func updateGravity(_ gravity: CGVector) {
        self.scene?.physicsWorld.gravity = gravity
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
        } else if(contact.bodyA.node is ExtraLife || contact.bodyB.node is ExtraLife) {
            let extraLife = (contact.bodyA.node is ExtraLife ? contact.bodyA.node : contact.bodyB.node) as! ExtraLife
            extraLife.hit()
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
        self.player.CurrentLevel = self.world.Levels.first!
        
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
        //self.background.run(SKAction.colorize(with: level.BackgroundColor(), colorBlendFactor: 0.6, duration: 0.5))
    }
}
