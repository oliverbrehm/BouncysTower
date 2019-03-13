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
    var lastX: CGFloat = 0.0

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
                self.showPause()
            }
            self.pauseButton.zPosition = NodeZOrder.overlay
            self.pauseButton.position = CGPoint(
                x: world.width / 2.0 - pauseButton.frame.size.width / 2.0,
                y: world.height / 2.0 - pauseButton.frame.size.height / 2.0)
            self.cameraNode.addChild(self.pauseButton)
                        
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
        
        if(state.runningState == .running) {
            world.updateWallY(player.position.y)
        }
        
        if(state.runningState == .running) {
            player.update(dt: dt)
        }
        
        self.updateGame(dt)
        
        state.lastTime = currentTime
    }
    
    func showPause() {
        self.pause()
        self.pausedOverlay.show()
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
        
        self.state.runningState = .running
        self.pauseButton.isHidden = false
        
        self.world.isPaused = false
        self.player.isPaused = false
        self.pauseButton.isHidden = false
        self.pausedOverlay.hide()
        
        self.player.reset()
        self.player.position = CGPoint(x: 0.0, y: world.absoluteZero() + player.size.height / 2.0)
        
        self.state.currentGameTime = 0.0
                
        AdvertisingController.Default.presentIfNeccessary(returnScene: self.scene!, completionHandler: {})
        
        self.checkShowTutorial(.move)
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
        var image: String?
        var imageHeight: CGFloat = 0.0
        
        switch tutorial {
        case .move:
            message = "Touch and hold to move. "
                + "Use the entire left half of the screen to move left and the right half to move right."
            image = "leftright"
            imageHeight = 80.0
            
        case .wallJump:
            message = "Great, you reached the next Level! Did you notice: "
                + "You get an extra boost upwards if you jump against the wall! "
                + "If you roll left or right on the platform, you gain more speed."
            
        case .combos:
            message = "You get a higher score if you do combos. "
                + "Always keep rolling by holding your touch while on the platform. "
                + "You have to jump at least two platforms at once to get a combo."
            image = "combo"
            imageHeight = 160.0
            
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
            self.run(SKAction.wait(forDuration: 0.3)) {
                self.pause()
                InfoBox.showOnce(in: self, text: message, imageName: image, imageHeight: imageHeight) {
                    Config.standard.setTutorialShown(tutorial)
                    self.resume()
                }
            }
        }
    }
    
    func touchDown(atPoint pos: CGPoint) {
        self.movePlayer(pos: pos)
        lastX = pos.x
    }
    
    func touchMoved(toPoint pos: CGPoint) {
        self.movePlayer(pos: pos)
    }
    
    private func movePlayer(pos: CGPoint) {
        if(state.runningState == .running && state.allowJump) {
            if pos.x < self.frame.size.width / 2.0 {
                player.startMoving(directionLeft: true)
            } else {
                player.startMoving(directionLeft: false)
            }
        }
    }
    
    func touchUp(atPoint pos: CGPoint) {
        player.stopMoving()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self.view)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self.view)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.view)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.view)) }
    }
}
