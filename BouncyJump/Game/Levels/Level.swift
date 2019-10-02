//
//  Level.swift
//  BouncyJump
//
//  Created by Oliver Brehm on 25.09.18.
//  Copyright © 2018 Oliver Brehm. All rights reserved.
//

import Foundation
import SpriteKit

class Level: SKNode, LevelConfiguration {
    private var platformY: CGFloat
    private var backgroundY: CGFloat
    
    private var backgroundTiles: [SKSpriteNode] = []
    
    private var platforms: [Platform] = []
    private let maxPlatforms = 30
    private var wallY: CGFloat = 0.0
    private var wallTiles: [SKSpriteNode] = []
    private let maxWallTiles = 350
    private var lastSpawnedPlatform: Platform?
    private var currentPlatformNumber = 0
    
    private var levelPlatformIndex = 1
    private var speedEaseIn: CGFloat = 999999999.0
    
    var texturePlatform: SKTexture?
    var texturePlatformEnds: SKTexture?
    var textureWall: SKTexture?
    var textureBackground: SKTexture?
    var textureStaticBackground: SKTexture?
    
    private let backgroundHeight: CGFloat = 500.0
    
    var reached = false
    
    let world: World
    
    init(world: World) {
        self.world = world
        backgroundY = 0.0
        platformY = 0.0
        super.init()
        
        self.platformY = self.firstPlatformOffset * world.height
        
        self.spawnBackground(above: backgroundHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        world = World()
        backgroundY = 0.0
        platformY = 0.0
        super.init(coder: aDecoder)
    }

    var multiplicator: Int {
        return 1
    }
    
    var backgroundColor: SKColor {
        return SKColor.black
    }
    
    var platformMinFactor: CGFloat {
        return 0.01
    }
    
    var platformMaxFactor: CGFloat {
        return 1.0
    }
    
    // of screen height
    var platformYDistance: CGFloat {
        return 0.3
    }
    
    var numberOfPlatforms: Int {
        return 30
    }
    
    var levelSpeed: CGFloat {
        return 1.0
    }
    
    // of screen height
    var firstPlatformOffset: CGFloat {
        return 4.0
    }
    
    var amientParticleName: String? {
        return nil
    }
    
    func removeAllPlatforms() {
        for node in self.platforms {
            node.removeFromParent()
        }
        self.platforms.removeAll()
    }
    
    func reset() {
        self.levelPlatformIndex = 1
        self.platformY = 0.0
    }
    
    var topPlatformY: CGFloat {
        return platforms.last?.position.y ?? 0.0
    }
    
    var isLastPlatform: Bool {
        return self.levelPlatformIndex == self.numberOfPlatforms
    }
    
    var isFinished: Bool {
        return self.levelPlatformIndex > self.numberOfPlatforms
    }
    
    var gameSpeed: CGFloat {
        return min(self.speedEaseIn, self.levelSpeed)
    }
    
    func getPlatform(platformNumber: Int, yDistance: CGFloat = -1.0) -> Platform? {
        if(self.isFinished) {
            return nil
        }
        
        if(yDistance < 0) {
            platformY += self.platformYDistance * world.height
        } else {
            platformY += yDistance
        }
                
        let levelWidth = world.width - 2 * World.wallWidth
        
        var x: CGFloat = 0.0
        
        var platform: Platform?
        
        if(self.isLastPlatform) {
            platform = EndLevelPlatform(
                width: world.width,
                level: self,
                platformNumber: platformNumber, platformNumberInLevel: currentPlatformNumber,
                backgroundColor: self.backgroundColor)
            self.spawnBackground(above: platformY)
        } else {
            let minWidth = levelWidth * self.platformMinFactor
            let maxWidth = levelWidth * self.platformMaxFactor
            
            let w = CGFloat.random(in: minWidth ..< maxWidth)
            x = CGFloat.random(in: -levelWidth / 2.0 + w / 2.0
                ..< levelWidth / 2.0 - w / 2.0)
            platform = StandardPlatform(width: w, texture: self.texturePlatform, textureEnds: self.texturePlatformEnds,
                                        level: self, platformNumber: platformNumber, platformNumberInLevel: currentPlatformNumber)
            lastSpawnedPlatform?.nextPlatform = platform
            lastSpawnedPlatform = platform
            self.spawnBackground(above: platformY)
        }

        platform!.position = CGPoint(x: x, y: platformY)
        
        currentPlatformNumber += 1

        return platform!
    }
    
    func spawnBackground(above y: CGFloat) {
        if let texture = self.textureBackground {
            let size = CGSize(width: world.width, height: world.width * texture.size().height / texture.size().width)
            
            while(self.backgroundY < y + 2 * size.height) {
                let background = SKSpriteNode(texture: texture, color: self.backgroundColor, width: world.width)
                background.colorBlendFactor = 1.0
                background.position = CGPoint(x: 0.0, y: self.backgroundY + size.height / 2.0)
                background.zPosition = NodeZOrder.background
                
                self.addChild(background)
                
                self.backgroundY += size.height
                self.backgroundTiles.append(background)
            }
        }
    }
    
    func spawnWallTilesForPlatform(platform: Platform) {
        self.spawnWallTiles(above: platform.position.y)
    }
    
    func spawnWallTiles(above y: CGFloat) {
        while(self.wallY <= y + 2 * world.width) {
            let left = SKSpriteNode(texture: self.textureWall, color: SKColor.white, size: CGSize(width: World.wallWidth, height: World.wallWidth))
            left.zPosition = NodeZOrder.world
            let right = SKSpriteNode(texture: self.textureWall, color: SKColor.white, size: CGSize(width: World.wallWidth, height: World.wallWidth))
            right.zPosition = NodeZOrder.world
            right.xScale = -1
            
            self.addChild(left)
            self.addChild(right)
            
            self.wallTiles.append(left)
            self.wallTiles.append(right)
            
            left.position = CGPoint(x: -world.width / 2.0 + World.wallWidth / 2.0, y: self.wallY)
            right.position = CGPoint(x: world.width / 2.0 - World.wallWidth / 2.0, y: self.wallY)
            
            self.wallY += World.wallWidth
        }
        
        while(self.wallTiles.count > maxWallTiles) {
            self.wallTiles.first?.removeFromParent()
            self.wallTiles.removeFirst()
        }
    }
    
    func updatePlatforms(for player: Player) {
        let playerBottom =  self.convert(player.position, from: player.world!).y - player.size.height / 2.0
        let sceneHeight = self.scene?.size.height ?? 500.0
        
        if(player.state == .onPlatform) {
            // landing on platform: remove platforms under player and deactivate collisions
            var toRemove: [Platform] = []
            for platform in platforms {
                if platform.position.y < playerBottom - sceneHeight {
                    toRemove.append(platform)
                } else if(playerBottom < platform.top - 0.25 * player.size.height) {
                    platform.deactivateCollisions()
                }
            }
            // remove platforms
            for platform in toRemove {
                self.removePlatform(platform)
            }
        } else if(player.state == .falling) {
            // falling: activate collisions for platforms underneath player
            for platform in platforms {
                if(playerBottom > platform.top - 0.25 * player.size.height) {
                    platform.activateCollisions()
                } else {
                    platform.deactivateCollisions()
                    break
                }
            }
        }
    }
    
    private func removePlatform(_ platform: Platform) {
        platform.removeFromParent()
        if let index = platforms.firstIndex(of: platform) {
            platforms.remove(at: index)
        }
        
        while let wallTile = wallTiles.first, wallTile.position.y < platform.position.y {
            wallTile.removeFromParent()
            wallTiles.removeFirst()
        }
        
        while let backgroundTile = backgroundTiles.first, backgroundTile.position.y < platform.position.y - backgroundTile.size.height / 2.0 {
            backgroundTile.removeFromParent()
            backgroundTiles.removeFirst()
        }
    }
    
    func spawnPlatform(scene: Game, number: Int, numberOfCoins: Int? = nil) {
        self.levelPlatformIndex += 1
        
        if let platform = self.getPlatform(platformNumber: number) {
            self.addChild(platform)
            self.platforms.append(platform)
            platform.setup()
            
            if(self.platforms.count > self.maxPlatforms) {
                self.platforms.removeFirst().removeFromParent()
            }
            
            let n = numberOfCoins ?? ResourceManager.standard.consumeCoins()
            let platformSize = CGSize(width: platform.size.width, height: Platform.height)
            let platformInWorld = self.convert(platform.position, to: scene.world)
            let coinPlatformMargin: CGFloat = platformSize.width * 0.175
            scene.world.coinManager.spawnHorizontalLine(
                origin: CGPoint(x: platformInWorld.x, y: platformInWorld.y + platformSize.height / 2.0 + Coin.size / 2.0 + 2.0),
                width: platformSize.width - 2 * coinPlatformMargin, n: n)
            
            platform.deactivateCollisions()
            
            self.spawnWallTilesForPlatform(platform: platform)
        }
    }
    
    func fadeIn() {
        self.alpha = 0.0
        self.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    func fadeOutAndRemove() {
        self.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
        ]))
    }
    
    func easeInSpeed() {
        self.speedEaseIn = 0.0
        
        let easeInDuration = 5.0 // seconds
        let easeInStepTime = 0.25 // seconds
        let n = Int(easeInDuration / easeInStepTime)
        let easeInStep = self.levelSpeed / CGFloat(n)

        self.run(SKAction.repeat(SKAction.sequence([
            SKAction.wait(forDuration: easeInStepTime),
            SKAction.run {
                self.speedEaseIn += easeInStep
            }
        ]), count: n))
    }
}
