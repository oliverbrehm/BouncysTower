//
//  GameScene.swift
//  BouncyJump
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
    let pausedOverlay = OverlayPause()
    var pauseButton = IconButton(image: "pause")
    
    // abstract callbacks to be overridden
    func setup() {} // abstract
    func updateGame(_ dt: TimeInterval) {} // abstract
    func hitPlatform(platform: Platform) {} // abstract
    func hitCoin(coin: Coin) {} // abstract
    
    override func sceneDidLoad() {
        self.backgroundColor = SKColor.black
    }
    
    override func didMove(to view: SKView) {
        if(player.parent == nil) {
            self.physicsWorld.contactDelegate = self
            self.physicsWorld.gravity = CGVector(dx: 0, dy: Config.physicsYFactor * (-9.81))
            
            self.player.initialize(world: self.world, scene: self)
            
            self.camera = cameraNode
            self.addChild(cameraNode)
            
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
                x: world.width / 2.0 - pauseButton.frame.size.width / 2.0 - Config.roundedDisplayMargin,
                y: world.height / 2.0 - pauseButton.frame.size.height / 2.0  - Config.roundedDisplayMargin)
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
        if(self.state.runningState == .running) {
            self.pause()
            self.pausedOverlay.show()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node is Platform || contact.bodyB.node is Platform {
            print("START    contact platform!")
        }
        
        
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
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node is Platform || contact.bodyB.node is Platform {
            print("END contact platform!")
        }
    }
    
    func resetGame() {
        AudioManager.standard.playBackgroundMusic(backgroundMusic: .level)

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
        
        self.resume()
        
        if let game = self.gameViewController {
            let presented = AdvertisingController.shared.presentIfNeccessary(in: game) {
                self.resume()
            }
            if(presented) {
                self.pause()
            }
        }
        
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
        case is LevelBase2:
            self.checkShowTutorial(.wallJump)
        case is LevelWood:
            self.checkShowTutorial(.combos)
        default:
            break
        }
    }
    
    func checkShowTutorial(_ tutorial: Tutorial, brick: Brick? = nil) {
        let imageName = (brick != nil) ? brick?.textureName : tutorial.imageName
        
        guard !tutorial.message.isEmpty else { return }
        
        if(Config.standard.shouldShow(tutorial: tutorial)) {
            self.run(SKAction.wait(forDuration: 0.3)) {
                InfoBox.show(in: self, text: tutorial.message, imageName: imageName, imageHeight: tutorial.imageHeight, onShow: {
                    self.pause()
                }, completion: {
                    Config.standard.setTutorialShown(tutorial)
                    self.resume()
                })
            }
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self.view)
            self.movePlayer(pos: pos)
            lastX = pos.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            self.moveForTouch(touch)
        }
    }
    
    private func moveForTouch(_ touch: UITouch) {
        let pos = touch.location(in: self.view)
        self.movePlayer(pos: pos)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nTouchesEnded = touches.count
        if let e = event, let v = self.view, let eventTouches = e.touches(for: v) {
            let nTouchesTotal = eventTouches.count
            if(nTouchesEnded == nTouchesTotal) {
                player.stopMoving()
            } else {
                // not all touches ended -> find touch that is still there and move in this direction
                for touch in eventTouches {
                    if(!touches.contains(touch)) {
                        moveForTouch(touch)
                        return
                    }
                }
            }
        }
    }
}
