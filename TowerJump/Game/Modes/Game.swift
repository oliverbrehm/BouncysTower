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
    static let gameOverLineUnderPlayerPercent: CGFloat = 0.7

    // members
    var gameViewController: GameViewController?
    var state = GameState()

    // nodes
    let player = Player()
    let world = World()
    let cameraNode = Camera()
    let background = SKSpriteNode.init(color: SKColor.black, size: CGSize.zero)
    let pausedOverlay = OverlayPause()
    var pauseButton = IconButton(image: "pause")
    
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
        if(self.state.lastTime < 0.0) {
            self.state.lastTime = currentTime
        }
        var dt = currentTime - self.state.lastTime
        if(self.state.timeWasPaused) {
            dt = 0.0
            self.state.timeWasPaused = false
        }
        
        if(state.runningState == .started || state.runningState == .running) {
            world.updateWallY(player.position.y)
        }
        
        if(state.runningState == .running) {
            player.update(dt: dt)
        }
        
        self.updateGame(dt)
        
        // self.updateDeviceMotionControl(dt: dt) // TODO REMOVE
        
        state.lastTime = currentTime
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
        if(player.state == .falling && (contact.bodyA.node is Platform || contact.bodyB.node is Platform)) {
            let platform = contact.bodyA.node is Platform ? contact.bodyA.node as! Platform : contact.bodyB.node as! Platform
            player.landOnPlatform(platform: platform)
            world.landOnPlatform(platform: platform, player: player)
            self.hitPlatform(platform: platform)
        } else if(contact.bodyA.node?.name == "Wall" || contact.bodyB.node?.name == "Wall") {
            player.hitWall()
        } else if(contact.bodyA.node is Collectable || contact.bodyB.node is Collectable) {
            let collectable = (contact.bodyA.node is Collectable ? contact.bodyA.node : contact.bodyB.node) as! Collectable
            collectable.hit()
            if let coin = collectable as? Coin {
                self.hitCoin(coin: coin)
            }
        }
    }
    
    func resetGame() {
        self.resume()

        world.create(self)
        self.state.gameOverY = world.absoluteZero()
        
        self.state.runningState = .started
        self.pauseButton.isHidden = false
        
        self.world.isPaused = false
        self.player.isPaused = false
        self.pauseButton.isHidden = false
        self.pausedOverlay.hide()
        
        self.player.reset()
        self.player.position = CGPoint(x: 0.0, y: world.absoluteZero() + player.size.height / 2.0)
        
        self.state.currentGameTime = 0.0
                
        AdvertisingController.Default.presentIfNeccessary(returnScene: self.scene!, completionHandler: {})
    }
    
    func pause() {
        self.state.runningState = .paused
        self.pauseButton.isHidden = true 
        
        self.world.isPaused = true
        self.player.isPaused = true
        self.physicsWorld.speed = 0.0
    }
     
    func resume() {
        self.pausedOverlay.hide()
        self.state.runningState = .running
        self.pauseButton.isHidden = false
        self.state.timeWasPaused = true
        
        self.world.isPaused = false
        self.player.isPaused = false
        self.physicsWorld.speed = 1.0
    }
    
    func run() {
        self.state.runningState = .running
        
        self.checkShowTutorial(.move)
    }
    
    func levelReached(level: Level) {
        switch level {
        case is Level02:
            self.checkShowTutorial(.wallJump)
        case is Level03:
            self.checkShowTutorial(.combos)
        default:
            break
        }
    }
    
    func checkShowTutorial(_ tutorial: Tutorial) {
        let message: String
        
        switch tutorial {
        case .move:
            message = "Touch and hold to move. "
                + "Use the entire left half of the screen to move left and the right half to move right."
            
        case .wallJump:
            message = "Great, you reached the next Level! Did you notice: "
                + "You get an extra boost upwards if you jump against the wall, try it."
            
        case .combos:
            message = "You get a higher score if you do combos. "
                + "Always keep rolling by holding your touch while on the platform. "
                + "You have to jump at least two platforms at once to get a combo."
            
        case .bricks:
            message = "Cool, you collected a loose brick! "
                + "Use it in the main screen to build your own personal tower."
            
        case .extraLives:
            message = "Hey, you found an extra life! "
                + "If you fall down, you can decide to use it and it will save you once."
            
        case .shop:
            message = "You've collected a lot of coins! Why not visit the shop? "
                + "You can get extra lives and shiny bricks for your personal tower! "
                + "Click on the coin icon in the menu any time to open the shop."
        }
        
        if(Config.standard.shouldShow(tutorial: tutorial)) {
            self.pause()
            InfoBox.showOnce(in: self, text: message) {
                Config.standard.setTutorialShown(tutorial)
                self.resume()
            }
        }
    }
}
