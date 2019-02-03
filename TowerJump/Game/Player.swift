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
    
    public var World : World?
    
    public var CurrentPlatform : Platform?
    
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
        
        self.State = .OnPlatform
        self.Score = 0
        
        self.particleEmitter.particleBirthRate = 0.0
    }
    
    public func Jump()
    {
        self.run(SKAction.scale(to: 1.0, duration: 0.15))

        if(self.State == PlayerState.OnPlatform)
        {
            let vxMax : CGFloat = 2000.0
            let vx : CGFloat = abs(self.physicsBody!.velocity.dx)
            
            let xVelocityFactor : CGFloat = 1.0 + min((vx / vxMax), 2.0)

            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: xVelocityFactor * Player.JUMP_IMPULSE))
            self.State = PlayerState.Jumping
        }
    }
    
    public func StartMoving() {
        self.run(SKAction.scale(to: 0.85, duration: 0.15))
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
    
    public func PlatformNumber() -> Int {
        return self.CurrentPlatform?.PlatformNumber ?? 0
    }
}
