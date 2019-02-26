//
//  Player.swift
//  TowerJump
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    enum PlayerState {
        case onPlatform
        case jumping
        case falling
    }
    
    static let size: CGFloat = 35.0
    static let jumpImpulse: CGFloat = 35.0
    static let superJumpImpulse: CGFloat = 120.0
    
    /*private let readyActionKey = "READY_ACTION"
    private let shrinkActionKey = "SHRINK_ACTION"
    private let growActionKey = "GROW_ACTION"*/
    
    var world: World?
    
    var currentPlatform: Platform?
    
    var score = 0
    //var jumpReadyTime = 0.25
 
    private var _state: PlayerState = .onPlatform
    private let perfectJumpDetector = PerfectJumpDetector()
    
    var state: PlayerState {
        get {
            return _state
        } set {
            if(_state != newValue) {
                _state = newValue
                self.world?.currentLevel?.updateCollisionTests(player: self)
            }
        }
    }
    
    //private var jumpReady = false
    //private var loadingJump = false
    
    private var movingDirectionLeft: Bool? = true
    
    private let particleEmitter = SKEmitterNode(fileNamed: "ScoreParticle")!
    
    init() {
        super.init(texture: SKTexture(imageNamed: "player"), color: SKColor.red, size: CGSize(width: Player.size, height: Player.size))
        
        self.physicsBody = SKPhysicsBody.init(circleOfRadius: Player.size / 2.0)
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.angularDamping = 0.8
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = NodeCategories.player
        self.physicsBody?.collisionBitMask = NodeCategories.platform | NodeCategories.wall
        self.physicsBody?.contactTestBitMask = NodeCategories.platform | NodeCategories.player | NodeCategories.coin
        self.physicsBody?.friction = 3.0
        self.physicsBody?.mass = 0.05
        
        self.zPosition = NodeZOrder.player
        
        self.particleEmitter.particleBirthRate = 10.0
        self.addChild(self.particleEmitter)
        
        self.perfectJumpDetector.setup(player: self)
    }
    
    func initialize(world: World, scene: Game) {
        self.world = world
        self.particleEmitter.targetNode = scene
        self.particleEmitter.particleBirthRate = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.angularVelocity = 0.0
        self.zRotation = 0.0
        
        self.currentPlatform = nil
        self.state = .onPlatform
        self.score = 0
        
        self.particleEmitter.particleBirthRate = 0.0
    }
    
    /*
    func releaseMove() {

        if(!self.jumpReady) {
            self.removeJumpLoadingActions()
        } else if(self.state == PlayerState.onPlatform) // jump if ready
        {
            let vxMax: CGFloat = 2000.0
            let vx: CGFloat = abs(self.physicsBody!.velocity.dx)
            
            let xVelocityFactor: CGFloat = 1.0 + min((vx / vxMax), 2.0)
            
            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: xVelocityFactor * Player.jumpImpulse))
            self.state = PlayerState.jumping
            
            self.run(SoundController.standard.getSoundAction(action: .jump))
            
            self.removeJumpLoadingActions()

            self.jumpReady = false
            
            self.perfectJumpDetector.playerLeftPlatform()
        }
        
        self.loadingJump = false
    }*/
    
    /*private func removeJumpLoadingActions() {
        self.removeAction(forKey: readyActionKey)
        self.removeAction(forKey: shrinkActionKey)
        self.run(SKAction.scale(to: 1.0, duration: 0.1), withKey: growActionKey)
        self.run(SKAction.colorize(with: SKColor.orange, colorBlendFactor: 0.0, duration: 0.05))
    }*/
    
    func superJump() {
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: Player.superJumpImpulse))
        self.state = PlayerState.jumping

        self.run(SoundController.standard.getSoundAction(action: .superJump))
        
        let particelEmitter = SKEmitterNode(fileNamed: "SuperJump")!
        particelEmitter.targetNode = self.scene
        particelEmitter.position = CGPoint(x: 0.0, y: (self.world?.height ?? 0.0) / 2.0)
        self.scene?.camera?.addChild(particelEmitter)
        
        particelEmitter.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run {
                particelEmitter.particleBirthRate = 0.0
            },
            SKAction.wait(forDuration: 2.0),
            SKAction.removeFromParent()
        ]))
    }
    
    /*
    func startMoving(directionLeft: Bool) {
        self.removeAction(forKey: self.growActionKey)
        
        self.loadingJump = true
        
        self.run(SKAction.scale(to: 0.75, duration: self.jumpReadyTime), withKey: shrinkActionKey)
        
        let readyAction = SKAction.sequence([
            SKAction.wait(forDuration: jumpReadyTime),
            SKAction.run {
                self.jumpReady = true
            },
            SKAction.colorize(with: SKColor.orange, colorBlendFactor: 1.0, duration: 0.1)
        ])
        self.run(readyAction, withKey: readyActionKey)
    }*/
    
    func startMoving(directionLeft: Bool) {
        var impulseStrength = 0.0
        
        if(self.movingDirectionLeft == nil || self.movingDirectionLeft != directionLeft) {
            // started moving or direction changed
            impulseStrength = 5.0
            
            if let p = self.physicsBody {
                if(directionLeft && p.velocity.dx > 0           // steering left but moving right
                    || !directionLeft && p.velocity.dx < 0   // steering right but moving left
                    ) {
                    // increase impule to help change moving direction
                    impulseStrength = 15.0
                }
            }
        }
        
        if(impulseStrength > 0) {
            if(directionLeft) {
                self.physicsBody?.applyImpulse(CGVector(dx: -impulseStrength, dy: 0.0))
            } else {
                self.physicsBody?.applyImpulse(CGVector(dx: impulseStrength, dy: 0.0))
            }
        }

        self.movingDirectionLeft = directionLeft
    }
    
    func stopMoving() {
        if(self.state == .onPlatform) {
            self.jump()
        }
        
        self.movingDirectionLeft = nil
    }
    
    func jump() {
        let vxMax: CGFloat = 2000.0
        let vx: CGFloat = abs(self.physicsBody!.velocity.dx)
        
        let xVelocityFactor: CGFloat = 1.0 + min((vx / vxMax), 2.0)
        
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: xVelocityFactor * Player.jumpImpulse))
        self.state = PlayerState.jumping
        
        self.run(SoundController.standard.getSoundAction(action: .jump))
        
        self.perfectJumpDetector.playerLeftPlatform()
    }
    
    func update(dt: TimeInterval) {
        if let p = self.physicsBody {
            if(p.velocity.dy < -0.1) {
                self.state = .falling
            } else if(self.state == .falling && p.velocity.dy > -0.000001) {
                self.state = .onPlatform
            }
        }
        
        let movingForce: CGFloat = 5000.0
        if let movingLeft = self.movingDirectionLeft {
            if(movingLeft) {
                self.move(x: -movingForce * CGFloat(dt))
            } else {
                self.move(x: movingForce * CGFloat(dt))
            }
        }
        
        if let rotation = self.physicsBody?.angularVelocity {
            if(abs(rotation) < 18.0) {
                self.particleEmitter.particleBirthRate = 0.0
            } else if(abs(rotation) < 30.0) {
                self.particleEmitter.particleBirthRate = 10.0
            } else {
                self.particleEmitter.particleBirthRate = 40.0
            }
        }
        
        self.perfectJumpDetector.update(dt: dt)
    }
    
    fileprivate func updateScoreLandingOn(platform: Platform) {
        let previousPlatformNumber = self.currentPlatform?.platformNumber ?? 0
        let nPlatformsJumped = platform.platformNumber - previousPlatformNumber
        let platformBonus = nPlatformsJumped > 0 ? platform.score() * self.perfectJumpDetector.scoreMultiplicator : 0
        self.score += (nPlatformsJumped * nPlatformsJumped) + platformBonus
    }
    
    func landOnPlatform(platform: Platform) {
        updateScoreLandingOn(platform: platform)

        self.state = PlayerState.onPlatform
        self.physicsBody?.velocity.dy = 0.0
        self.currentPlatform = platform
        
        self.perfectJumpDetector.playerLandedOnPlatform(platform)
        
        if(self.movingDirectionLeft == nil) {
            // user not moving left or right -> auto jump
            self.jump()
        }
    }
    
    func hitWall() {
        if(self.state == PlayerState.jumping && self.physicsBody!.velocity.dy > 0.0) {
            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 0.4 * Player.jumpImpulse))
        }
        
        if let pb = self.physicsBody {
            if(self.position.x < 0.0) {
                // left wall, rotate right after collision
                pb.angularVelocity = -abs(pb.angularVelocity)
            } else {
                // right wall, rotate left after collision
                pb.angularVelocity = abs(pb.angularVelocity)
            }
        }
    }
    
    func useExtralife() {
        self._state = .jumping
        self.zRotation = 0.0
        self.position = CGPoint(x: 0.0, y: self.position.y + 100.0)
        
        self.world?.currentLevel?.updateCollisionTests(player: self)

        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 100.0))
    }
    
    func move(x: CGFloat) {
        var dx: CGFloat = 0.0
        
        if(self.state == PlayerState.jumping || self.state == PlayerState.falling) {
            dx = x * 0.7
        } else if(self.state == PlayerState.onPlatform) {
            dx = x * 2.5
        }
        
        self.physicsBody?.applyForce(CGVector(dx: dx, dy: 0.0))
    }
    
    func neutralizeHorizontalSpeed() {
        self.physicsBody?.angularVelocity = (self.physicsBody?.angularVelocity ?? 0.0) * 0.95
    }
    
    func platformNumber() -> Int {
        return self.currentPlatform?.platformNumber ?? 0
    }
}
