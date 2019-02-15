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

class Game: SKScene, SKPhysicsContactDelegate {
    // CONSTANTS
    static let GAME_OVER_LINE_UNDER_PLAYER_PERCENT: CGFloat = 0.7

    // members
    var GameViewController : GameViewController?
    var State = GameState()

    // nodes
    let player = Player()
    let world = World()
    let cameraNode = Camera()
    let background = SKSpriteNode.init(color: SKColor.black, size: CGSize.zero)
    let pausedOverlay = OverlayPause()
    var pauseButton = Button(caption: "")
    
    // abstract callbacks to be overridden
    func setup() {} // abstract
    func updateGame(_ dt: TimeInterval) {} // abstract
    func hitPlatform(platform: Platform) {} // abstract
    func hitCoin(coin: Coin) {} // abstract
    
    // TODO gravity code REMOVE
    // private var lastGravityX: CGFloat = 0.0
    // private let motionManager = CMMotionManager()
    
    override func sceneDidLoad() {
        self.backgroundColor = SKColor.black
    }
    
    override func didMove(to view: SKView) {
        if(player.parent == nil) {
            self.physicsWorld.contactDelegate = self
            
            self.player.initialize(world: self.world, scene: self)
            
            self.camera = cameraNode
            self.addChild(cameraNode)
            
            self.background.size = self.size
            self.background.zPosition = NodeZOrder.background
            self.cameraNode.addChild(self.background)
            
            self.addChild(world)
            self.addChild(player)
            
            resetGame()

            self.cameraNode.addChild(self.pausedOverlay)
            self.pausedOverlay.setup(game: self)
            self.pausedOverlay.hide()
            
            self.pauseButton = Button(caption: "||", size: CGSize(width: World.wallWidth, height: 30.0), fontSize: 18.0, fontColor: SKColor.black, backgroundColor: SKColor.init(white: 1.0, alpha: 0.8), pressedColor: SKColor.white)
            self.pauseButton.action = {
                self.pause()
                self.pausedOverlay.show()
            }
            self.pauseButton.zPosition = NodeZOrder.overlay
            self.pauseButton.position = CGPoint(
                x: world.width / 2.0 - pauseButton.frame.size.width / 2.0,
                y: world.height / 2.0 - pauseButton.frame.size.height / 2.0)
            self.cameraNode.addChild(self.pauseButton)
            
            // self.motionManager.startDeviceMotionUpdates() // TODO REMOVE
            
            self.setup()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(self.State.lastTime < 0.0) {
            self.State.lastTime = currentTime
        }
        var dt = currentTime - self.State.lastTime
        if(self.State.timeWasPaused) {
            dt = 0.0
            self.State.timeWasPaused = false
        }
        
        if(State.runningState == .started || State.runningState == .running)
        {
            world.updateWallY(player.position.y)
        }
        
        if(State.runningState == .running) {
            player.update()
        }
        
        self.updateGame(dt)
        
        // self.updateDeviceMotionControl(dt: dt) // TODO REMOVE
        
        State.lastTime = currentTime
    }
    
    // TODO remove, experimental motion control
    private func updateDeviceMotionControl(dt: CGFloat) {
        /*
        if(self.motionManager.isDeviceMotionAvailable) {
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
    }
    
    func updateGravity(_ gravity: CGVector) {
        // self.scene?.physicsWorld.gravity = gravity // TODO REMOVE
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(player.state == .Falling && (contact.bodyA.node is Platform || contact.bodyB.node is Platform))
        {
            let platform = contact.bodyA.node is Platform ? contact.bodyA.node as! Platform : contact.bodyB.node as! Platform
            player.landOnPlatform(platform: platform)
            world.landOnPlatform(platform: platform, player: player)
            self.hitPlatform(platform: platform)
        } else if(contact.bodyA.node?.name == "Wall" || contact.bodyB.node?.name == "Wall") {
            player.hitWall()
        } else if(contact.bodyA.node is Coin || contact.bodyB.node is Coin) {
            let coin = (contact.bodyA.node is Coin ? contact.bodyA.node : contact.bodyB.node) as! Coin
            coin.hit()
            self.world.removeCoin(coin: coin)
            self.hitCoin(coin: coin)
        } else if(contact.bodyA.node is ExtraLife || contact.bodyB.node is ExtraLife) {
            let extraLife = (contact.bodyA.node is ExtraLife ? contact.bodyA.node : contact.bodyB.node) as! ExtraLife
            extraLife.hit()
        }
    }
    
    func resetGame()
    {
        self.resume()

        world.create(self)
        self.State.GameOverY = world.absoluteZero()
        
        self.State.runningState = .started
        self.pauseButton.isHidden = false
        
        self.world.isPaused = false
        self.player.isPaused = false
        self.pauseButton.isHidden = false
        self.pausedOverlay.hide()
        
        self.player.reset()
        self.player.position = CGPoint(x: 0.0, y: world.absoluteZero() + player.size.height / 2.0)
        self.player.currentLevel = self.world.levels.first!
        
        self.State.currentGameTime = 0.0
                
        AdvertisingController.Default.PresentIfNeccessary(returnScene: self.scene!, completionHandler: {})
    }
    
    func pause()
    {
        self.State.runningState = .paused
        self.pauseButton.isHidden = true 
        
        self.world.isPaused = true
        self.player.isPaused = true
        self.physicsWorld.speed = 0.0
    }
     
    func resume()
    {
        self.pausedOverlay.hide()
        self.State.runningState = .running
        self.pauseButton.isHidden = false
        self.State.timeWasPaused = true
        
        self.world.isPaused = false
        self.player.isPaused = false
        self.physicsWorld.speed = 1.0
    }
    
    func levelReached(level: Level) {
        //self.background.run(SKAction.colorize(with: level.BackgroundColor(), colorBlendFactor: 0.6, duration: 0.5))
    }
}
