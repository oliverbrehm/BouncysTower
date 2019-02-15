//
//  Player.swift
//  TowerJump
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Player : SKSpriteNode
{
    enum PlayerState {
        case OnPlatform
        case Jumping
        case Falling
    }
    
    static let size : CGFloat = 35.0;
    static let jumpImpulse : CGFloat = 35.0
    static let superJumpImpulse : CGFloat = 120.0
    private let readyActionKey = "readyAction"
    var world : World?
    
    var currentPlatform: Platform?
    var currentLevel: Level?
    
    var score = 0
    
    private var _state : PlayerState = .OnPlatform
    var state : PlayerState {
        get {
            return _state
        } set {
            if(_state != newValue) {
                _state = newValue
                self.world?.updateCollisionTests(player: self)
            }
        }
    }
    
    private var jumpReady = false
    private var loadingJump = false
    
    private let particleEmitter = SKEmitterNode(fileNamed: "ScoreParticle")!
    
    init() {
        super.init(texture: SKTexture(imageNamed: "player"), color: SKColor.red, size: CGSize(width: Player.size, height: Player.size))
        
        self.physicsBody = SKPhysicsBody.init(circleOfRadius: Player.size / 2.0)
        self.physicsBody?.allowsRotation = true;
        self.physicsBody?.angularDamping = 0.8
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = NodeCategories.player
        self.physicsBody?.collisionBitMask = NodeCategories.platform | NodeCategories.wall
        self.physicsBody?.contactTestBitMask = NodeCategories.platform | NodeCategories.player | NodeCategories.coin;
        self.physicsBody?.friction = 3.0
        self.physicsBody?.mass = 0.05
        
        self.zPosition = NodeZOrder.player
        
        self.particleEmitter.particleBirthRate = 10.0
        self.addChild(self.particleEmitter)
    }
    
    func initialize(world: World, scene: Game) {
        self.world = world
        self.particleEmitter.targetNode = scene
        self.particleEmitter.particleBirthRate = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset()
    {
        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.angularVelocity = 0.0
        self.zRotation = 0.0
        
        self.currentPlatform = nil
        self.state = .OnPlatform
        self.score = 0
        
        self.particleEmitter.particleBirthRate = 0.0
    }
    
    func releaseMove()
    {
        self.removeAction(forKey: readyActionKey)

        // jump if ready
        if(self.state == PlayerState.OnPlatform && self.jumpReady)
        {
            let vxMax : CGFloat = 2000.0
            let vx : CGFloat = abs(self.physicsBody!.velocity.dx)
            
            let xVelocityFactor : CGFloat = 1.0 + min((vx / vxMax), 2.0)

            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: xVelocityFactor * Player.jumpImpulse))
            self.state = PlayerState.Jumping
            
            self.run(SoundController.standard.getSoundAction(action: .jump))
            
            self.run(SKAction.scale(to: 1.0, duration: 0.1))
            self.run(SKAction.colorize(with: SKColor.orange, colorBlendFactor: 0.0, duration: 0.05))
            self.jumpReady = false
        }
        
        self.loadingJump = false
    }
    
    func superJump()
    {
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: Player.superJumpImpulse))
        self.state = PlayerState.Jumping

        self.run(SoundController.standard.getSoundAction(action: .superJump))
    }
    
    func startMoving() {
        self.loadingJump = true
        
        let jumpReadyTime = 0.2
        self.run(SKAction.scale(to: 0.85, duration: jumpReadyTime))
        
        let readyAction = SKAction.sequence([
            SKAction.wait(forDuration: jumpReadyTime),
            SKAction.run {
                self.jumpReady = true
            },
            SKAction.colorize(with: SKColor.orange, colorBlendFactor: 1.0, duration: 0.05)
        ])
        self.run(readyAction, withKey: readyActionKey)
    }
    
    func update()
    {
        if let p = self.physicsBody {
            if(p.velocity.dy < -0.1)
            {
                self.state = .Falling
            } else if(self.state == .Falling && p.velocity.dy > -0.000001) {
                self.state = .OnPlatform
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
    }
    
    func landOnPlatform(platform: Platform)
    {
        // calculate score
        let previousPlatformNumber = self.currentPlatform?.platformNumber ?? 0
        let nPlatformsJumped = platform.platformNumber - previousPlatformNumber
        let platformBonus = nPlatformsJumped > 0 ? platform.score() : 0
        self.score = self.score + (nPlatformsJumped * nPlatformsJumped) + platformBonus

        self.state = PlayerState.OnPlatform
        self.physicsBody?.velocity.dy = 0.0
        self.currentPlatform = platform
        
        if(self.jumpReady && !self.loadingJump) {
            // user already released but has not yet landed yet
            // -> auto jump
            self.releaseMove()
        }
    }
    
    func hitWall()
    {
        if(self.state == PlayerState.Jumping && self.physicsBody!.velocity.dy > 0.0) {
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
        self._state = .Jumping
        self.zRotation = 0.0
        self.position = CGPoint(x: 0.0, y: self.position.y + 100.0)
        
        self.world?.updateCollisionTests(player: self)

        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 100.0))
    }
    
    func move(x : CGFloat)
    {
        var dx : CGFloat = 0.0
        
        if(self.state == PlayerState.Jumping || self.state == PlayerState.Falling) {
            dx = x * 12.0
        } else if(self.state == PlayerState.OnPlatform) {
            dx = x * 16.0
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
