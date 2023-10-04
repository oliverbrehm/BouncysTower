//
//  World.swift
//  BouncysTower
//
//  Created by Oliver Brehm on 26.06.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import SpriteKit

class World: SKNode {
    var currentLevel: Level?
    let coinManager = CoinManager()

    var levels: [Level] = []
    private var currentPlatformNumber = 0
    
    static let wallWidth: CGFloat = 35.0
    
    // walls are invisible nodes, used only for collision with player, textures are spawned as tiles with platforms
    private let leftWall = SKSpriteNode.init(color: SKColor.clear, size: CGSize(width: World.wallWidth, height: 0.0))
    private let rightWall = SKSpriteNode.init(color: SKColor.clear, size: CGSize(width: World.wallWidth, height: 0.0))
    
    private var ambientParticles: SKEmitterNode?
    private var staticLevelBackground: SKSpriteNode?
    
    var height: CGFloat = 0.0
    var width: CGFloat = 0.0
    
    func create(_ scene: Game) {
        self.currentPlatformNumber = 0
        self.removeAllChildren()
        
        self.width = scene.size.width * scene.xScale
        self.height = scene.size.height * scene.yScale
        
        self.coinManager.setup(world: self)

        // MARK: - left wall
        leftWall.size.height = height * 3.0
        leftWall.position.x = -width / 2.0 + World.wallWidth / 2.0
        leftWall.physicsBody = SKPhysicsBody.init(rectangleOf: leftWall.size)
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = NodeCategories.wall
        leftWall.physicsBody?.contactTestBitMask = NodeCategories.player | NodeCategories.wall
        leftWall.physicsBody?.collisionBitMask = 0x0
        leftWall.name = "Wall"
        self.addChild(leftWall)
        leftWall.zPosition = NodeZOrder.world
        
        // MARK: - right wall
        rightWall.size.height = height * 3.0
        rightWall.position.x = width / 2.0 - World.wallWidth / 2.0
        rightWall.physicsBody = SKPhysicsBody.init(rectangleOf: rightWall.size)
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.categoryBitMask = NodeCategories.wall
        rightWall.physicsBody?.contactTestBitMask = NodeCategories.player | NodeCategories.wall
        rightWall.physicsBody?.collisionBitMask = 0x0
        rightWall.name = "Wall"
        self.addChild(rightWall)
        rightWall.zPosition = NodeZOrder.world
        
        // levels
        self.levels = [
            LevelBase1(world: self),
            LevelBase2(world: self),
            LevelDesert(world: self),
            LevelWood(world: self),
            LevelSnow(world: self),
            LevelSunset(world: self),
            LevelMoon(world: self),
            LevelMoonStars(world: self),
            LevelFinal(world: self)
        ]
        
        self.currentLevel = nil
        self.spawnNextLevel()
        scene.levelReached(level: self.currentLevel!)
        
        self.spawnFloor()
    }
    
    func spawnFloor() {
        let floorTexture = SKTexture(imageNamed: "platformBase")
        let platform = Platform(width: width - 2 * World.wallWidth,
                                texture: floorTexture, textureEnds: nil,
                                level: self.currentLevel!, platformNumber: 0, platformNumberInLevel: 0)
        platform.position = CGPoint(x: 0.0, y: absoluteZero())
        platform.activateCollisions()
        self.addChild(platform)
    }
    
    func spawnNextLevel() {
        let y = topPlatformY()
        if self.levels.count > 0 {
            self.currentLevel?.fadeOutAndRemove()
            self.currentLevel = self.levels.removeFirst()

            if let level = self.currentLevel {
                self.addChild(level)
                if !(level is LevelBase1) {
                    level.fadeIn()
                }
                level.position = CGPoint(x: 0.0, y: y)
                
                self.initAmbientParticlesFor(level: level)
                self.initBackgroundFor(level: level)
            }
        }
    }
    
    private func initAmbientParticlesFor(level: Level) {
        if let currentParticles = self.ambientParticles {
            currentParticles.removeFromParent()
        }
        
        if let particleFile = level.amientParticleName, let camera = self.scene?.camera {
            self.ambientParticles = SKEmitterNode(fileNamed: particleFile)
            if let particles = self.ambientParticles {
                camera.addChild(particles)
                particles.position.y = self.height / 2.0
                particles.targetNode = self
                particles.particlePositionRange.dx = self.width
            }
        }
    }
    
    private func initBackgroundFor(level: Level) {
        if let bg = self.staticLevelBackground {
            bg.run(SKAction.fadeOut(withDuration: 0.5)) {
                bg.removeFromParent()
            }
            self.staticLevelBackground = nil
        }
        
        if let texture = level.textureStaticBackground, let camera = self.scene?.camera {
            let texRatio = texture.size().height / texture.size().width
            let worldRatio = self.height / self.width
            
            if texRatio > worldRatio {
                staticLevelBackground = SKSpriteNode(texture: texture, color: SKColor.white, width: self.width)
            } else {
                staticLevelBackground = SKSpriteNode(texture: texture, color: SKColor.white, height: self.height)
            }
            
            staticLevelBackground!.colorBlendFactor = 1.0
            staticLevelBackground!.zPosition = NodeZOrder.background - 0.1
            camera.addChild(staticLevelBackground!)
            staticLevelBackground?.run(SKAction.fadeIn(withDuration: 0.5))
        }
    }
    
    func spawnPlatformsAbove(y: CGFloat) {
        while (self.currentLevel != nil && !self.currentLevel!.isFinished)
                && (topPlatformY() - y < 3.0 * height) {
            self.spawnPlatform()
        }
    }
    
    func spawnPlatform(numberOfCoins: Int? = nil) {
        guard let scene = scene as? Game else { return }

        self.currentLevel!.spawnPlatform(
            scene: scene,
            number: self.currentPlatformNumber,
            numberOfCoins: numberOfCoins)
        self.currentPlatformNumber += 1
    }
    
    func topPlatformY() -> CGFloat {
        if let l = self.currentLevel {
            return l.topPlatformY + l.position.y
        }
        
        return self.absoluteZero()
    }
    
    func landOnPlatform(platform: Platform, player: Player) {
        if !platform.level.reached {
            (self.scene as? Game)?.levelReached(level: platform.level)
        }
        platform.hitPlayer(player: player, world: self)
        
        self.coinManager.removeCoinsUnder(player: player)
    }

    func updateWallY(_ y: CGFloat) {
        self.leftWall.position.y = y
        self.rightWall.position.y = y
    }

    func absoluteZero() -> CGFloat {
        return -height / 2.0 + (Platform.height) / 2.0
    }
    
    func makeExplosion(at position: CGPoint, color: SKColor = SKColor.white) {
        if let emitter = SKEmitterNode(fileNamed: "JumpParticle") {
            self.addChild(emitter)
            emitter.position = position
            emitter.particleColor = color
            emitter.run(SKAction.wait(forDuration: 0.1)) {
                emitter.particleBirthRate = 0.0
                emitter.run(SKAction.wait(forDuration: 1.0)) {
                    emitter.removeFromParent()
                }
            }
        }
    }
}
