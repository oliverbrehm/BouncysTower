//
//  Player.swift
//  BouncysTower
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
        
    private let jumpImpulse: CGFloat = 3500.0
    private lazy var superJumpImpulse: CGFloat = 2.5 * jumpImpulse
    private let movingForce: CGFloat = 200000 * Config.screenWidthFactor
    private let onPlatformForceMultiplicator: CGFloat = 1.8
    private let actionScale = "PLAYER_SCALE"
    
    var world: World?
    
    var currentPlatform: Platform?
    
    var score = 0
 
    private let perfectJumpDetector = PerfectJumpDetector()
    
    var controllerMovingDirectionLeft: Bool? // nil: not moving, false: left, true: right
    
    private(set) var state: PlayerState = .onPlatform {
        didSet {
            Logger.standard.playerState(message: "STATE: \(state)")
            self.world?.currentLevel?.updatePlatforms(for: self)
        }
    }
    
    var longestCombo: Int {
        return perfectJumpDetector.longestCombo
    }
    
    private(set) var hitWallSinceJumping = false
    
    private let rollingParticleEmitter = SKEmitterNode(fileNamed: "ScoreParticle")!
    let comboParticleEmitter = SKEmitterNode(fileNamed: "ComboParticle")!
    
    init(jumpOnTouch: Bool = false) {
        let playerDiameter: CGFloat = 36
        super.init(texture: SKTexture(imageNamed: "player"), color: SKColor.red, size: CGSize(width: playerDiameter, height: playerDiameter))
        
        self.isUserInteractionEnabled = jumpOnTouch
        
        self.zPosition = NodeZOrder.player
        
        self.physicsBody = SKPhysicsBody.init(circleOfRadius: playerDiameter / 2.0)
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.angularDamping = 0.8
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = NodeCategories.player
        self.physicsBody?.collisionBitMask = NodeCategories.platform | NodeCategories.wall
        self.physicsBody?.contactTestBitMask = NodeCategories.platform | NodeCategories.player | NodeCategories.consumable
        self.physicsBody?.friction = 3.0
        self.physicsBody?.mass = 3.0
        
        addChild(rollingParticleEmitter)
        addChild(comboParticleEmitter)
        comboParticleEmitter.particleBirthRate = 0
        rollingParticleEmitter.particleBirthRate = 0
    }
    
    func initialize(world: World, scene: Game) {
        self.world = world

        self.perfectJumpDetector.setup(player: self)
        
        comboParticleEmitter.targetNode = scene
        comboParticleEmitter.particleColorSequence = nil
        comboParticleEmitter.particleColorBlendFactor = 1
        comboParticleEmitter.particleColor = SKColor.random()
        
        rollingParticleEmitter.targetNode = scene
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let p = self.physicsBody {
            if p.velocity.dy == 0.0 {
                self.jump()
            }
        }
    }
    
    func reset() {
        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.angularVelocity = 0
        self.zRotation = 0
        
        self.currentPlatform = nil
        self.state = .onPlatform
        self.score = 0
        
        self.rollingParticleEmitter.particleBirthRate = 0
        self.comboParticleEmitter.particleBirthRate = 0
        
        self.perfectJumpDetector.setup(player: self)
    }
    
    func gameover() {
        self.rollingParticleEmitter.particleBirthRate = 0
        self.comboParticleEmitter.particleBirthRate = 0
    }
    
    func nextLevelJump() {
        self.bigJump(impulse: 1.5 * superJumpImpulse)
        
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
    
    func useExtralife() {
        self.zRotation = 0.0
        self.position = CGPoint(x: 0.0, y: self.position.y + 100.0)
        self.physicsBody?.velocity = CGVector.zero
        
        // expand platforms above
        if let currentPlatform = currentPlatform {
            var platform: Platform? = currentPlatform
            for _ in 0 ..< 8 {
                if let current = platform {
                    current.expand()
                } else {
                    break
                }
                
                platform = platform?.nextPlatform
            }
        }

        bigJump(impulse: superJumpImpulse * 0.75)
    }
    
    func superJump() {
        bigJump(impulse: superJumpImpulse)
    }
    
    private func bigJump(impulse: CGFloat) {
        guard let physicsBody = physicsBody else { return }
        
        physicsBody.velocity = CGVector(dx: physicsBody.velocity.dx, dy: 0)
        physicsBody.applyImpulse(CGVector(dx: 0.0, dy: impulse))
        state = PlayerState.jumping
        perfectJumpDetector.playerHitWall()
        
        run(SoundAction.superJump.action)
    }

    var movingDirectionLeft: Bool {
        return self.physicsBody?.velocity.dx ?? 0.0 < 0 ? true : false
    }
    
    func startMoving(directionLeft: Bool) {
        if self.movingDirectionLeft != directionLeft {
            // direction changed
            self.physicsBody?.velocity.dx = 0.0
        }
        
        self.controllerMovingDirectionLeft = directionLeft
        
        self.removeAction(forKey: self.actionScale)
        self.run(SKAction.scale(to: 0.8, duration: 0.3), withKey: self.actionScale)
    }
    
    func stopMoving() {
        if self.state == .onPlatform {
            self.jump()
        }
        
        self.controllerMovingDirectionLeft = nil
        
        self.removeAction(forKey: self.actionScale)
        self.run(SKAction.scale(to: 1.0, duration: 0.3), withKey: self.actionScale)
    }
    
    func jump() {
        let vxMax: CGFloat = 2000.0
        let vx: CGFloat = abs(physicsBody!.velocity.dx)
        
        let xVelocityFactor: CGFloat = 1.0 + min((vx / vxMax), 2.0)
        
        physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: xVelocityFactor * jumpImpulse))
        state = PlayerState.jumping
        
        playJumpSound()
        perfectJumpDetector.playerJumped(from: currentPlatform)
        
        if let world = world {
            world.makeExplosion(at: self.position)
        }
    }
    
    func playJumpSound() {
        if perfectJumpDetector.comboCount > 0 {
            self.run(SoundAction.bigJump.action)
        } else {
            self.run(SoundAction.jump.action)
        }
    }
    
    func update(dt: TimeInterval) {
        if let p = self.physicsBody, self.state != .falling {
            if self.state == .onPlatform && p.velocity.dy < -50.0 {
                // falling from platform
                Logger.standard.playerState(message: "--- falling from platform, dy: \(p.velocity.dy)")
                self.state = .falling
            } else if self.state == .jumping && p.velocity.dy < 0.0 {
                // falling after jump
                self.state = .falling
            }
        }
        
        if self.state == .falling {
            self.world?.currentLevel?.updatePlatforms(for: self)
        }
        
        if let movingDirectionLeft = self.controllerMovingDirectionLeft {
            if movingDirectionLeft {
                self.move(x: -movingForce * CGFloat(dt))
            } else {
                self.move(x: movingForce * CGFloat(dt))
            }
        }
        
        if let rotation = self.physicsBody?.angularVelocity {
            if abs(rotation) < 18.0 {
                self.rollingParticleEmitter.particleBirthRate = 0.0
            } else if abs(rotation) < 30.0 {
                self.rollingParticleEmitter.particleBirthRate = 10.0
            } else {
                self.rollingParticleEmitter.particleBirthRate = 40.0
            }
        }
    }
    
    func updateScoreLandingOn(platform: Platform) {
        let previousPlatformNumber = self.currentPlatform?.platformNumber ?? 0
        Logger.standard.logScore(message: "--------------")

        let nPlatformsJumped = min(10, platform.platformNumber - previousPlatformNumber)
        Logger.standard.logScore(message: "nPlatforms: \(nPlatformsJumped)")

        let baseScore = nPlatformsJumped > 0 ? platform.score() * nPlatformsJumped : 0
        Logger.standard.logScore(message: "baseScore: \(baseScore)")
        
        let comboMultiplicator = self.perfectJumpDetector.scoreMultiplicator
        Logger.standard.logScore(message: "comboMultiplicator: \(comboMultiplicator)")
        
        let personalTowerMultiplicator = max(1, TowerBricks.standard.rows.count)
        Logger.standard.logScore(message: "personalTowerMultiplicator: \(personalTowerMultiplicator)")
        
        let landingScore = baseScore * comboMultiplicator + baseScore * personalTowerMultiplicator
        Logger.standard.logScore(message: "landingScore: \(landingScore)")
        
        let toalScore = landingScore * (currentPlatform?.level.multiplicator ?? 1)
        Logger.standard.logScore(message: "totalScore: \(toalScore)")
        self.score += toalScore
    }
    
    func landOnPlatform(platform: Platform) {
        if self.state == .onPlatform {
            return
        }
        
        updateScoreLandingOn(platform: platform)

        self.physicsBody?.velocity.dy = 0.0
        self.state = .onPlatform
        self.currentPlatform = platform
        self.hitWallSinceJumping = false
        
        if self.controllerMovingDirectionLeft == nil {
            // user not moving left or right -> auto jump
            self.run(SKAction.wait(forDuration: 0.07)) {
                if self.controllerMovingDirectionLeft == nil && self.state == .onPlatform {
                    self.jump()
                }
            }
        }
    }
    
    func hitWall() {
        if self.state == PlayerState.jumping && !hitWallSinceJumping && self.physicsBody!.velocity.dy > 0.0 {
            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 0.5 * jumpImpulse))
            self.world?.makeExplosion(at: self.position, color: Colors.menuForeground)
        }
        
        if let pb = self.physicsBody {
            pb.angularVelocity = -pb.angularVelocity
        }
        
        Logger.standard.playerState(message: "HIT WALL")
        self.perfectJumpDetector.playerHitWall()
        
        self.hitWallSinceJumping = true
    }
    
    func died() {
        self.perfectJumpDetector.reset()
    }
    
    func move(x: CGFloat) {
        var dx = x
        
        // while in the air, less force is needed because of friction
        if self.state == PlayerState.onPlatform {
            dx = x * self.onPlatformForceMultiplicator
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
