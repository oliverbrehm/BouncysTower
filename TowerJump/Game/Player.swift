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
    public enum PlayerState {
        case OnPlatform
        case Jumping
        case Falling
    }
    
    public static let SIZE : CGFloat = 35.0;
    public static let JUMP_IMPULSE : CGFloat = 35.0
    public static let SUPER_JUMP_IMPULSE : CGFloat = 120.0
    private let READY_ACTION_KEY = "readyAction"
    public var World : World?
    
    public var CurrentPlatform: Platform?
    public var CurrentLevel: Level?
    
    public var Score = 0
    
    private var state : PlayerState = .OnPlatform
    public var State : PlayerState {
        get {
            return state
        } set {
            if(state != newValue) {
                state = newValue
                self.World?.UpdateCollisionTests(player: self)
            }
        }
    }
    
    private var jumpReady = false
    private var loadingJump = false
    
    private let particleEmitter = SKEmitterNode(fileNamed: "ScoreParticle")!
    
    init() {
        super.init(texture: SKTexture(imageNamed: "player"), color: SKColor.red, size: CGSize(width: Player.SIZE, height: Player.SIZE))
        
        self.physicsBody = SKPhysicsBody.init(circleOfRadius: Player.SIZE / 2.0)
        self.physicsBody?.allowsRotation = true;
        self.physicsBody?.angularDamping = 0.8
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = NodeCategories.Player
        self.physicsBody?.collisionBitMask = NodeCategories.Platform | NodeCategories.Wall
        self.physicsBody?.contactTestBitMask = NodeCategories.Platform | NodeCategories.Player | NodeCategories.Coin;
        self.physicsBody?.friction = 3.0
        self.physicsBody?.mass = 0.05
        
        self.zPosition = NodeZOrder.Player
        
        self.particleEmitter.particleBirthRate = 10.0
        self.addChild(self.particleEmitter)
    }
    
    public func Initialize(world: World, scene: Game) {
        self.World = world
        self.particleEmitter.targetNode = scene
        self.particleEmitter.particleBirthRate = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func Reset()
    {
        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.angularVelocity = 0.0
        self.zRotation = 0.0
        
        self.CurrentPlatform = nil
        self.State = .OnPlatform
        self.Score = 0
        
        self.particleEmitter.particleBirthRate = 0.0
    }
    
    public func ReleaseMove()
    {
        self.removeAction(forKey: READY_ACTION_KEY)

        // jump if ready
        if(self.State == PlayerState.OnPlatform && self.jumpReady)
        {
            let vxMax : CGFloat = 2000.0
            let vx : CGFloat = abs(self.physicsBody!.velocity.dx)
            
            let xVelocityFactor : CGFloat = 1.0 + min((vx / vxMax), 2.0)

            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: xVelocityFactor * Player.JUMP_IMPULSE))
            self.State = PlayerState.Jumping
            
            self.run(SoundController.Default.GetSoundAction(action: .Jump))
            
            self.run(SKAction.scale(to: 1.0, duration: 0.1))
            self.run(SKAction.colorize(with: SKColor.orange, colorBlendFactor: 0.0, duration: 0.05))
            self.jumpReady = false
        }
        
        self.loadingJump = false
    }
    
    public func SuperJump()
    {
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: Player.SUPER_JUMP_IMPULSE))
        self.State = PlayerState.Jumping

        self.run(SoundController.Default.GetSoundAction(action: .SuperJump))
    }
    
    public func StartMoving() {
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
        self.run(readyAction, withKey: READY_ACTION_KEY)
    }
    
    public func Update()
    {
        if let p = self.physicsBody {
            if(p.velocity.dy < -0.1)
            {
                self.State = .Falling
            } else if(self.State == .Falling && p.velocity.dy > -0.000001) {
                self.State = .OnPlatform
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
    
    public func LandOnPlatform(platform: Platform)
    {
        // calculate score
        let previousPlatformNumber = self.CurrentPlatform?.PlatformNumber ?? 0
        let nPlatformsJumped = platform.PlatformNumber - previousPlatformNumber
        let platformBonus = nPlatformsJumped > 0 ? platform.Score() : 0
        self.Score = self.Score + (nPlatformsJumped * nPlatformsJumped) + platformBonus

        self.State = PlayerState.OnPlatform
        self.physicsBody?.velocity.dy = 0.0
        self.CurrentPlatform = platform
        
        if(self.jumpReady && !self.loadingJump) {
            // user already released but has not yet landed yet
            // -> auto jump
            self.ReleaseMove()
        }
    }
    
    public func HitWall()
    {
        if(self.State == PlayerState.Jumping && self.physicsBody!.velocity.dy > 0.0) {
            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 0.4 * Player.JUMP_IMPULSE))
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
    
    public func UseExtralife() {
        self.state = .Jumping
        self.zRotation = 0.0
        self.position = CGPoint(x: 0.0, y: self.position.y + 100.0)
        
        self.World?.UpdateCollisionTests(player: self)

        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 100.0))
    }
    
    public func Move(x : CGFloat)
    {
        var dx : CGFloat = 0.0
        
        if(self.State == PlayerState.Jumping || self.State == PlayerState.Falling) {
            dx = x * 12.0
        } else if(self.State == PlayerState.OnPlatform) {
            dx = x * 16.0
        }
        
        self.physicsBody?.applyForce(CGVector(dx: dx, dy: 0.0))
    }
    
    public func NeutralizeHorizontalSpeed() {
        self.physicsBody?.angularVelocity = (self.physicsBody?.angularVelocity ?? 0.0) * 0.95
    }
    
    public func PlatformNumber() -> Int {
        return self.CurrentPlatform?.PlatformNumber ?? 0
    }
}
